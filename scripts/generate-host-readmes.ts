import { execFileSync } from "node:child_process";
import { access, readFile, readdir, writeFile } from "node:fs/promises";
import { join } from "node:path";

const BYTES_PER_GIBIBYTE = 1024 ** 3;
const KIBIBYTES_PER_GIBIBYTE = 1024 ** 2;
const FACTER_HOSTS_DIRECTORY = "modules/hosts/nixos";
const GENERATED_SECTION_START = "<!-- BEGIN GENERATED HOST SPECS -->";
const GENERATED_SECTION_END = "<!-- END GENERATED HOST SPECS -->";
const HOST_EMOJIS: Record<string, string> = {
  fallarbor: "🍃",
  mauville: "⚡",
  rustboro: "🪨",
  sootopolis: "🌊",
};

type Specification = readonly [component: string, details: string];

interface Disk {
  model?: string;
  resources?: Array<{
    type?: string;
    unit?: string;
    value_1?: number;
    value_2?: number;
  }>;
  sysfs_id?: string;
}

interface FacterReport {
  hardware?: {
    cpu?: Array<{ cores?: number; model_name?: string; siblings?: number }>;
    disk?: Disk[];
    graphics_card?: Array<{ model?: string; vendor?: { name?: string } }>;
  };
  smbios?: {
    bios?: { date?: string; vendor?: string; version?: string };
    chassis?: Array<{ chassis_type?: { name?: string } }>;
    memory_device?: Array<{ size?: number }>;
    system?: { manufacturer?: string; product?: string; version?: string };
  };
}

function isMeaningfulString(value: string | undefined): value is string {
  return value !== undefined && value !== "" && value !== "Default string";
}

function joinDetails(values: Array<string | undefined>): string {
  return values.filter(isMeaningfulString).join(" ");
}

function formatGibibytes(value: number): string {
  if (value === 0) {
    return "Unknown";
  }

  const gibibytes = value / KIBIBYTES_PER_GIBIBYTE;
  return Number.isInteger(gibibytes)
    ? `${gibibytes} GiB`
    : `${gibibytes.toFixed(1)} GiB`;
}

function describeModel(report: FacterReport): string {
  const system = report.smbios?.system;
  return joinDetails([system?.manufacturer, system?.version, system?.product]);
}

function describeCpu(report: FacterReport): string {
  const cpu = report.hardware?.cpu?.[0];
  if (cpu === undefined) {
    return "Unknown";
  }

  return [
    cpu.model_name ?? "Unknown",
    cpu.cores === undefined || cpu.cores === 0
      ? undefined
      : `${cpu.cores} cores`,
    cpu.siblings === undefined || cpu.siblings === 0
      ? undefined
      : `${cpu.siblings} threads`,
  ]
    .filter(isMeaningfulString)
    .join(" — ");
}

function describeMemory(report: FacterReport): string {
  const kibibytes = (report.smbios?.memory_device ?? []).reduce(
    (total, device) => total + (device.size ?? 0),
    0,
  );
  return formatGibibytes(kibibytes);
}

function describeDisk(disk: Disk): string {
  const bytes = (disk.resources ?? [])
    .filter(
      (resource) => resource.type === "size" && resource.unit === "sectors",
    )
    .reduce(
      (total, resource) =>
        total + (resource.value_1 ?? 0) * (resource.value_2 ?? 0),
      0,
    );
  const capacity =
    bytes === 0 ? undefined : `${Math.floor(bytes / BYTES_PER_GIBIBYTE)} GiB`;

  return [disk.model ?? "Unknown", capacity]
    .filter(isMeaningfulString)
    .join(" — ");
}

function uniqueDetails(values: string[]): string {
  return [...new Set(values.filter(isMeaningfulString))].join("; ");
}

function describeStorage(report: FacterReport): string {
  return uniqueDetails(
    (report.hardware?.disk ?? [])
      .filter((disk) => !disk.sysfs_id?.startsWith("/class/block/zram"))
      .map(describeDisk),
  );
}

function describeGraphics(report: FacterReport): string {
  return uniqueDetails(
    (report.hardware?.graphics_card ?? []).map((card) =>
      joinDetails([card.vendor?.name, card.model]),
    ),
  );
}

function specificationsFor(report: FacterReport): Specification[] {
  const model = describeModel(report);
  const bios = report.smbios?.bios;
  const specifications: Specification[] = [
    ["Platform", "NixOS"],
    ["Model", model],
    ["Chassis", report.smbios?.chassis?.[0]?.chassis_type?.name ?? ""],
    ["CPU", describeCpu(report)],
    ["Memory", describeMemory(report)],
    ["Storage", describeStorage(report)],
    ["Graphics", describeGraphics(report)],
    ["Firmware", joinDetails([bios?.vendor, bios?.version, bios?.date])],
  ];

  return specifications.filter(
    ([, details]) => details !== "" && details !== "Unknown",
  );
}

function renderTable(specifications: Specification[]): string {
  const rows = specifications.map(([component, details]) => [
    component,
    details.replaceAll("|", "\\|"),
  ]);
  const componentWidth = Math.max(
    "Component".length,
    ...rows.map(([component]) => component.length),
  );
  const detailsWidth = Math.max(
    "Details".length,
    ...rows.map(([, details]) => details.length),
  );
  const formatRow = (component: string, details: string): string =>
    `| ${component.padEnd(componentWidth)} | ${details.padEnd(detailsWidth)} |`;

  return [
    formatRow("Component", "Details"),
    `| ${"-".repeat(componentWidth)} | ${"-".repeat(detailsWidth)} |`,
    ...rows.map(([component, details]) => formatRow(component, details)),
  ].join("\n");
}

function renderGeneratedSection(
  hostName: string,
  report: FacterReport,
): string {
  const model = describeModel(report);
  const overview =
    model === "" ? "NixOS host managed by Hoenn." : `${model} running NixOS.`;
  const table = renderTable(specificationsFor(report));

  return [
    GENERATED_SECTION_START,
    "",
    `# ${HOST_EMOJIS[hostName.toLowerCase()]} ${hostName}`,
    "",
    "## Overview",
    "",
    overview,
    "",
    "## Specs",
    "",
    table,
    "",
    GENERATED_SECTION_END,
    "",
  ].join("\n");
}

function hostTitle(hostName: string): string {
  return `${hostName[0]?.toUpperCase()}${hostName.slice(1)}`;
}

function repositoryRoot(): string {
  return execFileSync("git", ["rev-parse", "--show-toplevel"], {
    encoding: "utf8",
  }).trim();
}

function manualReadmeContent(existingReadme: string): string {
  const sectionStart = existingReadme.indexOf(GENERATED_SECTION_START);
  const sectionEnd = existingReadme.indexOf(GENERATED_SECTION_END);
  if (sectionStart !== -1 && sectionEnd > sectionStart) {
    return existingReadme
      .slice(sectionEnd + GENERATED_SECTION_END.length)
      .trimStart();
  }

  if (
    existingReadme.startsWith("<!-- Generated by scripts/generate-host-readmes")
  ) {
    return "";
  }

  return existingReadme.trimStart();
}

async function hasFacterReport(hostDirectory: string): Promise<boolean> {
  try {
    await access(join(hostDirectory, "facter.json"));
    return true;
  } catch {
    return false;
  }
}

async function generateHostReadme(
  hostDirectory: string,
  hostName: string,
): Promise<void> {
  const facterPath = join(hostDirectory, "facter.json");
  const report = JSON.parse(await readFile(facterPath, "utf8")) as FacterReport;
  const readmePath = join(hostDirectory, "README.md");
  const existingReadme = await readFile(readmePath, "utf8").catch(() => "");
  const manualContent = manualReadmeContent(existingReadme);
  const generatedSection = renderGeneratedSection(hostTitle(hostName), report);
  const nextReadme = [generatedSection, manualContent]
    .filter((content) => content !== "")
    .join("\n");

  if (nextReadme !== existingReadme) {
    await writeFile(readmePath, nextReadme);
  }
}

async function main(): Promise<void> {
  process.chdir(repositoryRoot());

  const hostNames = await readdir(FACTER_HOSTS_DIRECTORY);
  for (const hostName of hostNames.sort()) {
    const hostDirectory = join(FACTER_HOSTS_DIRECTORY, hostName);
    if (await hasFacterReport(hostDirectory)) {
      await generateHostReadme(hostDirectory, hostName);
    }
  }
}

await main();

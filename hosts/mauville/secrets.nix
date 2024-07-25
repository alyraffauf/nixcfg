{
  age.secrets = {
    cloudflare.file = ../../secrets/cloudflare.age;

    lastfmId = {
      owner = "navidrome";
      file = ../../secrets/lastFM/apiKey.age;
    };

    lastfmSecret = {
      owner = "navidrome";
      file = ../../secrets/lastFM/secret.age;
    };

    spotifyId = {
      owner = "navidrome";
      file = ../../secrets/spotify/clientId.age;
    };

    spotifySecret = {
      owner = "navidrome";
      file = ../../secrets/spotify/clientSecret.age;
    };

    syncthingCert.file = ../../secrets/aly/syncthing/mauville/cert.age;
    syncthingKey.file = ../../secrets/aly/syncthing/mauville/key.age;
    transmission.file = ../../secrets/transmission.age;
  };
}

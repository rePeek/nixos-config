{ ... }:
{
  virtualisation.oci-containers.containers."nextcloud" = {
    image = "nextcloud:latest";
    ports = [ "9000:80" ];
    environment = {
      PUID = "20001";
      PGID = "100";
      TZ = "Asia/Shanghai";
    };
    extraOptions = [ "--privileged=true" ];
    # volumes = [
    #   "/public_data/nextcloud/config:/var/www/html/config"
    #   "/public_data/nextcloud/data:/var/www/html/data"
    # ];
  };
  # virtualisation.oci-containers.containers."mysql" = {
  #   image = "mysql:8.0";
  #   ports = ["3306:3306"];
  #   environment = {
  #     MYSQL_ROOT_PASSWORD="xzllll.com";
  #     MYSQL_USER="nextcloud";
  #     MYSQL_PASSWORD="09ms22xc";
  #     MYSQL_DATABASE="nextcloud";
  #     MYSQL_ROOT_HOST="%";
  #   };
  #   volumes = [
  #     "/public_data/nextcloud/mysql:/var/lib/mysql"
  #   ];
  # };
}

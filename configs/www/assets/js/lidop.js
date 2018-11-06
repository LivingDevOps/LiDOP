$(document).ready(function() {

  var servers = {};
  servers['Jenkins'] = {};
  servers['Jenkins']['service'] = "jenkins";
  servers['Jenkins']['prefix'] = "/jenkins";
  servers['Jenkins']['port'] = "";
  servers['Jenkins']['protocol'] = "http";
  servers['Jenkins']['image'] = "/img/jenkins-sml.png";

  servers['GitBucket'] = {};
  servers['GitBucket']['service'] = "gitbucket";
  servers['GitBucket']['prefix'] = "/gitbucket/";
  servers['GitBucket']['port'] = "";
  servers['GitBucket']['protocol'] = "http";
  servers['GitBucket']['image'] = "/img/gitBucket-sml.png";

  servers['OpenLdap'] = {};
  servers['OpenLdap']['service'] = "ldap";
  servers['OpenLdap']['subdomain'] = 
  servers['OpenLdap']['prefix'] = "/ldap";
  servers['OpenLdap']['port'] = "";
  servers['OpenLdap']['protocol'] = "https";
  servers['OpenLdap']['image'] = "/img/openldap-sml.jpeg";

  servers['User'] = {};
  servers['User']['service'] = "ldap";
  servers['User']['subdomain'] = 
  servers['User']['prefix'] = "/user";
  servers['User']['port'] = "";
  servers['User']['protocol'] = "https";
  servers['User']['image'] = "/img/ssu-sml.png";

  servers['Portainer'] = {};
  servers['Portainer']['service'] = "portainer";
  servers['Portainer']['prefix'] = "/portainer/#";
  servers['Portainer']['port'] = "";
  servers['Portainer']['protocol'] = "http";
  servers['Portainer']['image'] = "/img/portainer-sml.png";

  servers['Consul'] = {};
  servers['Consul']['service'] = "consul";
  servers['Consul']['prefix'] = "/ui";
  servers['Consul']['port'] = "";
  servers['Consul']['protocol'] = "http";
  servers['Consul']['image'] = "/img/consul-sml.png";

  servers['Adminer'] = {};
  servers['Adminer']['service'] = "db";
  servers['Adminer']['prefix'] = "/adminer";
  servers['Adminer']['port'] = "";
  servers['Adminer']['protocol'] = "http";
  servers['Adminer']['image'] = "/img/adminer-sml.png";

  servers['Registry'] = {};
  servers['Registry']['service'] = "docker-registry-ui";
  servers['Registry']['prefix'] = "/registry";
  servers['Registry']['port'] = "";
  servers['Registry']['protocol'] = "http";
  servers['Registry']['image'] = "/img/docker-sml.png";

  servers['SonarQube'] = {};
  servers['SonarQube']['service'] = "sonarqube";
  servers['SonarQube']['prefix'] = "/sonarqube/";
  servers['SonarQube']['port'] = "";
  servers['SonarQube']['protocol'] = "http";
  servers['SonarQube']['image'] = "/img/sonarQube-sml.png";

  servers['Nexus'] = {};
  servers['Nexus']['service'] = "nexus";
  servers['Nexus']['prefix'] = "/nexus";
  servers['Nexus']['port'] = "";
  servers['Nexus']['protocol'] = "http";
  servers['Nexus']['image'] = "/img/nexus-sml.png";

  servers['Cadvisor'] = {};
  servers['Cadvisor']['service'] = "cadvisor";
  servers['Cadvisor']['prefix'] = "";
  servers['Cadvisor']['port'] = ":8086";
  servers['Cadvisor']['protocol'] = "http";
  servers['Cadvisor']['image'] = "/img/cadvisor-sml.png";

  servers['Elk'] = {};
  servers['Elk']['service'] = "kibana";
  servers['Elk']['prefix'] = "/kibana";
  servers['Elk']['port'] = "";
  servers['Elk']['protocol'] = "http";
  servers['Elk']['image'] = "/img/elk-sml.png";

  servers['Tomcat'] = {};
  servers['Tomcat']['service'] = "tomcat";
  servers['Tomcat']['prefix'] = "/tomcat";
  servers['Tomcat']['port'] = "";
  servers['Tomcat']['protocol'] = "http";
  servers['Tomcat']['image'] = "/img/tomcat-sml.png";

  servers['Selenium'] = {};
  servers['Selenium']['service'] = "selenium";
  servers['Selenium']['prefix'] = "/grid/console";
  servers['Selenium']['port'] = "";
  servers['Selenium']['protocol'] = "http";
  servers['Selenium']['image'] = "/img/selenium-sml.png";

  servers['Awx'] = {};
  servers['Awx']['service'] = "awx";
  servers['Awx']['prefix'] = "/awx";
  servers['Awx']['port'] = "";
  servers['Awx']['protocol'] = "http";
  servers['Awx']['image'] = "/img/awx-sml.png";

  counter=0;
  Object.keys(servers).forEach(function(element) {
    var url = "/v1/catalog/service/" + servers[element]['service'];
    servers['Jenkins']['port'] = "";
    $("#Service" + counter)
          .children("h3").text("No " + element);

    $.getJSON(url, function(data) {
      console.log("Url: " + url);
      console.log("Data: " + data.length);
      servers['Jenkins']['port'] = "";
      if(data.length != 0){
        counter++;

        if(window.location.protocol == "https:" && servers[element]["subdomain"] == true) {
          $("#Service" + counter)
            .attr("href", window.location.href.replace(window.location.protocol + "//" ,"https://" + servers[element]['service'] + "." ));
        }
        else if(window.location.protocol == "https:") {
          $("#Service" + counter)
            .attr("href", "https://" + window.location.hostname + servers[element]['port'] + servers[element]['prefix']);
        }
        else {     
          $("#Service" + counter)
            .attr("href", servers[element]['protocol'] + "://" + window.location.hostname + servers[element]['port'] + servers[element]['prefix']);
        }

        $("#Service" + counter)
          .css("background-repeat", "no-repeat")
          .css("background-position", "center bottom");
        $("#Service" + counter)
          .css("background-repeat", "no-repeat")
          .css("background-position", "center bottom");
          $("#Service" + counter)
          .children("h3").text(element + " is running");
        $("#Service" + counter)
          .children("img")
          .attr("src",servers[element]['image'])
          .attr("width", "60%")
          .attr("height", "60%");    
      }
      else{
        console.log("Url: " + url + " not found");
      }
    })
  });
});
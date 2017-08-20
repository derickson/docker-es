FROM docker.elastic.co/kibana/kibana:5.5.1
MAINTAINER Dave Erickson <david.erickson@gmail.com>

USER root

RUN chown -R kibana:kibana /usr/share/kibana
RUN chown -R kibana:kibana /usr/share/kibana/optimize
RUN chown -R kibana:kibana /usr/share/kibana/optimize/bundles
RUN chmod -R +rw /usr/share/kibana/optimize
RUN chmod g+s /usr/share/kibana/optimize/bundles


USER kibana
## RUN bin/kibana-plugin install https://github.com/nreese/enhanced_tilemap/releases/download/v5.1.1-2016-12-14/kibana.zip
## RUN bin/kibana-plugin install https://github.com/sivasamyk/logtrail/releases/download/0.1.6/logtrail-5.x-0.1.6.zip

RUN kibana 2>&1 | grep -m 1 "Optimization of .* complete in .* seconds" 




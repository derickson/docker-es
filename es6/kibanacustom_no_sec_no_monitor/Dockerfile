FROM docker.elastic.co/kibana/kibana:6.0.0-rc1
MAINTAINER Dave Erickson <derickson@github>

USER root
RUN chmod -R +rw /usr/share/kibana/optimize/
RUN chown -R kibana /usr/share/kibana/optimize/

USER kibana

# Workaround https://github.com/elastic/kibana/issues/10724 and https://github.com/elastic/kibana/issues/6057
RUN XPACK_MONITORING_ENABLED=false XPACK_SECURITY_ENABLED=false  /usr/local/bin/kibana-docker 2>&1 | grep -m 1 "Optimization of .* complete in .* seconds"



#!/usr/bin/env python


from swift.container.replicator import ContainerReplicator
from swift.common.utils import parse_options, readconf

conf, options = parse_options(once=True)
conf = readconf(conf, section_name="container-replicator")

replicator = ContainerReplicator(conf)
replicator.run_once()

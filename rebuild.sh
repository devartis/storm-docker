#!/bin/bash

docker build -t="devartis/storm:1.0.2" storm
docker build -t="devartis/storm-nimbus:1.0.2" storm-nimbus
docker build -t="devartis/storm-supervisor:1.0.2" storm-supervisor
docker build -t="devartis/storm-ui:1.0.2" storm-ui

#!/bin/bash

# hack to control stellarium azimuth by true north heading from signalK

stellarium --startup-script=%f  &
sleep 5

while [[ -n "$(pidof stellarium)" ]]
do
    # magnetic variation
    MV=$(curl -s http://localhost:80/signalk/v1/api/vessels/self/navigation/magneticVariation/value)
    # magnetic heading
    MH=$(curl -s http://localhost:80/signalk/v1/api/vessels/self/navigation/headingMagnetic/value)
    # true heading
    HT=$(echo $MH + $MV | bc)
    # control stellarium azimuth
    curl -X POST -d "az=$HT" http://localhost:8090/api/main/view
  sleep 2
done


#!/usr/bin/env bash
rm ./../.box/lidop.offline.virtualbox.box 
vagrant up
vagrant package --output ./../.box/lidop.offline.virtualbox.box 

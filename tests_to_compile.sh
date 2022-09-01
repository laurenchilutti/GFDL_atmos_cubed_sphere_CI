#!/bin/sh -xe

./COMPILE solo nh 64bit repro intel clean
./COMPILE solo sw 64bit repro intel clean
./COMPILE solo hydro 64bit repro intel clean

#!/bin/sh

INSTANCE_IDS=i-33d4c7b8

aws ec2 $1-instances --instance-ids $INSTANCE_IDS


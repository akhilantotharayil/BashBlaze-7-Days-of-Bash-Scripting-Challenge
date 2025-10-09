#!/bin/bash

FILE="sample.txt"
echo "Hello from server!" > $FILE

for host in <CLIENT1_IP> <CLIENT2_IP>
do
  echo "Transferring $FILE to $host"
  scp $FILE ec2-user@$host:/home/ec2-user/
done

#!/bin/bash

sudo apt-get update 
sudo apt-get install nginx -y 
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Terraform in One-shot </h1>"

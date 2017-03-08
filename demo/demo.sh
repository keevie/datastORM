#!/bin/bash
set -ex

bundle install
pry test.rb

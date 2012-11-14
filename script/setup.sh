#!/bin/sh
set -e

# first do this for mountain lion: https://coderwall.com/p/1mni7w

pg_ctl -D /usr/local/var/postgres initdb
createuser expenselynx --createdb
createdb expenselynx_dev --username=expenselynx

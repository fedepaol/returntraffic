#!/bin/bash
#
ip -4 rule add pref 32765 table local
ip -4 rule del pref 0

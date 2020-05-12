#!/bin/bash
sed "s/tagVersion/$1/g" controller.json > controller-tag-version.json
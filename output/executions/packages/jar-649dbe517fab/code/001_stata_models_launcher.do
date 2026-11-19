adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
set more off
global directory "@@ACCTREPL_WORK@@/package"
cd "$directory/Code"
do 01-Models.do

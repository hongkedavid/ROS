supervisorctl stop localization
supervisorctl stop perception
supervisorctl stop prediction
supervisorctl stop routing
supervisorctl stop planning
supervisorctl stop control
supervisorctl stop dreamview
supervisorctl stop monitor

# Optional: stop recording
scripts/record_bag.sh stop

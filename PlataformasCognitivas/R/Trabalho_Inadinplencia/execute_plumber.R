# execute_plumber.R

# Execute plumber on port 8080 - Please, verify not exist other process using port 8080
plumber::plumb(file='plumber.R') $run(host = '0.0.0.0', port = 8080)
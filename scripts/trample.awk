function average(array, count)
{
    total = 0
     for (i in array) {
          total += array[i]
     }
     return total / count
}

BEGIN {
	request_count = 0
	GET_request_count = 0
	POST_request_count = 0
	iteration_count = 0
	session_count = 0
	timeout_count = 0
	total_time = 0
	TIMEOUT = 5
}
/GET/ {
	request_count++
	GET_request_count++
	request_timings[request_count] = $5
	request_statuses[request_count] = $6
	if ($5 > TIMEOUT) {
	  timeout_count++
	}    
}
/POST/ {
	request_count++
	POST_request_count++
	request_timings[request_count] = $5
	request_statuses[request_count] = $6
	if ($5 > TIMEOUT) {
	  timeout_count++
	}    
}
/ITERATION/ {
	iteration_count++
	iteration_timings[iteration_count] = $5
}
/SESSION/ {
	session_count++
	session_timings[session_count] = $5
}
/TRAMPLE/ {
	total_time = $4
}
END {
	printf "----------------------\n"
	printf "- Trample Statistics -\n"
	printf "----------------------\n"
	printf "Requests:\t%i\n", request_count
	printf "GET Requests:\t%i\n", GET_request_count
	printf "POST Requests:\t%i\n", POST_request_count
	printf "Timeouts:\t%i\n\n", timeout_count
	printf "Total Time (seconds):\t%f\n", total_time
	printf "Requests per second:\t%f\n", (request_count / total_time)
	printf "Average Request Time:\t%f\n", average(request_timings, request_count);
	printf "Average Iteration Time:\t%f\n", average(iteration_timings, iteration_count);
	printf "Average Session Time:\t%f\n", average(session_timings, session_count);
	printf "Timeout Rate:\t\t%f\n", timeout_count / request_count;
	printf "\n"
}
#replace {{token}} with your own API token
#replace {{api}} with your own API url - the URL of your AWX instance.

###############

for i in {1..10}
do
        echo Retrieving Failed Jobs, Workflows and Commands, page $i
        failedCommands=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/ad_hoc_commands/?page_size=200&page=$i"| jq '.results[] | select(.status|test ("failed")) | .id' 2>/dev/null`
        failedJobs=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/jobs/?page_size=200&page=$i" | jq '.results[] | select(.status|test ("failed")) | .id' 2>/dev/null`
        failedWorkflows=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/workflow_jobs/?page_size=200&page=$i" | jq '.results[] | select(.status|test ("failed")) | .id' 2>/dev/null`
        if [ -z "$failedJobs" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Failed Jobs. Moving to the next one.

        elif [ -z "$failedJobs" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Failed Jobs
        else
                for id in $failedJobs
                do
                        echo Deleting Failed Job $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/jobs/$id/
                done
        fi

        if [ -z "$failedCommands" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Failed Commands. Moving to the next one.

        elif [ -z "$failedCommands" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Failed Commands
        else
                for id in $failedCommands
                do
                        echo Deleting Failed Command $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/ad_hoc_commands/$id/
                done
        fi
        if [ -z "$failedWorkflows" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Failed Workflows. Moving to the next one.

        elif [ -z "$failedWorkflows" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Failed Workflows
        else
                for id in $failedWorkflows
                do
                        echo Deleting Failed Workflows $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/workflow_jobs/$id/
                done
        fi
done
###############
for i in {1..10}
do
        echo Retrieving Canceled Jobs, Workflows and Commands, page $i
        canceledCommands=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/ad_hoc_commands/?page_size=200&page=$i"| jq '.results[] | select(.status|test ("canceled")) | .id' 2>/dev/null`
        canceledJobs=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/jobs/?page_size=200&page=$i" | jq '.results[] | select(.status|test ("canceled")) | .id' 2>/dev/null`
        canceledWorkflows=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET "{{api}}api/v2/workflow_jobs/?page_size=200&page=$i" | jq '.results[] | select(.status|test ("canceled")) | .id' 2>/dev/null`
        if [ -z "$canceledJobs" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Canceled Jobs. Moving to the next one.

        elif [ -z "$canceledJobs" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Canceled Jobs
        else
                for id in $canceledJobs
                do
                        echo Deleting Canceled Job $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/jobs/$id/
                done
        fi

        if [ -z "$canceledCommands" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Canceled Commands. Moving to the next one.

        elif [ -z "$canceledCommands" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Canceled Commands
        else
                for id in $canceledCommands
                do
                        echo Deleting Canceled Command $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/ad_hoc_commands/$id/
                done
        fi
        if [ -z "$canceledWorkflows" ] && [ $? -ne 0 ]
        then
                echo Page $i does not have any Canceled Workflows. Moving to the next one.

        elif [ -z "$canceledWorkflows" ] && [ $? -eq 0 ]
        then
                echo Jobs list is clean of Canceled Workflows
        else
                for id in $canceledWorkflows
                do
                        echo Deleting Canceled Workflows $id
                        curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/workflow_jobs/$id/
                done
        fi
done
###############

echo Retrieving Project Update Jobs

#as I only have one project, I have directly referenced its ID here. However, for multiple projects, you'll need to have another API call that gets the project IDs and loops through them.

projectJobs=`curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X GET '{{api}}api/v2/projects/6/project_updates/' | jq '.results[].id' 2>/dev/null`
if [ -z "$projectJobs" ] && [ $? -eq 0 ]
then
        echo Jobs list is clean of Project Update Jobs
else
        for id in $projectJobs
        do
                echo  deleting project update $id
                curl -k -s -H 'Authorization: bearer {{token}}' -H 'Content-Type: application/json' -X DELETE {{api}}api/v2/project_updates/$id/
        done
fi

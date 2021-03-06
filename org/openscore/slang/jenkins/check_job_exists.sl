#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation checks if a job exists in Jenkins
#
# url:             the URL to Jenkins
# job_name:        the name of the job to check
# expected_status: true if the invoking flow expects the job to exist, false otherwise; affects the operation's results

namespace: org.openscore.slang.jenkins

operations:
  - check_job_exists:
      inputs:
        - url
        - job_name
        - expected_status
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            exists = j.has_job(job_name)
            expected_status2 = expected_status in ['true', 'True', 'TRUE']
            
            returnCode = '0'
            returnResult = 'Success'
            
            result = ''
            if (exists == True) and (expected_status2 == True):
              result = 'EXISTS_EXPECTED'
            elif (exists == True) and (expected_status2 == False):
              result = 'EXISTS_UNEXPECTED'
            else: 
              result = 'NOT_EXISTS'
            
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error checking job\'s existance: ' + job_name
            result = 'FAILURE'

      outputs:
        - exists
        - returnResult
        - result

      results:
        - EXISTS_EXPECTED: result == 'EXISTS_EXPECTED'
        - EXISTS_UNEXPECTED: result == 'EXISTS_UNEXPECTED'
        - NOT_EXISTS: result == 'NOT_EXISTS'
        - FAILURE: result == 'FAILURE'

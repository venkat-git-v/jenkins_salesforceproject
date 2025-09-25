pipeline {
agent { docker { image 'yourorg/sfdx-agent:latest' } }
options { ansiColor('xterm'); timestamps() }
stages {
stage('Checkout') {
steps { checkout scm }
}
stage('Authenticate') {
steps {
withCredentials([file(credentialsId: 'sfdc_jwt_key', variable: 'JWT_KEY'),
string(credentialsId: 'sfdc_client_id', variable: 'SF_CLIENT_ID'),
string(credentialsId: 'sfdc_username', variable: 'SF_USERNAME'),
string(credentialsId: 'sfdc_instance_url', variable: 'SF_INSTANCE_URL')]) {
sh '''
set -e
echo "Authenticating to Salesforce...Test"
sfdx auth:jwt:grant --clientid $SF_CLIENT_ID --jwtkeyfile $JWT_KEY --username $SF_USERNAME '''
}
}
}
stage('Validate (checkonly)') {
steps {
sh 'sfdx force:source:deploy -x manifest/package.xml --checkonly --testlevel RunLocalTests --}
}
stage('Deploy to Sandbox') {
steps {
sh 'sfdx force:source:deploy -x manifest/package.xml --testlevel RunLocalTests --wait 20'
}
}
stage('Post-Tests & Reports') {
steps {
sh 'sfdx force:apex:test:run --resultformat human --wait 20 || true'
}
}
}
post {
success { echo 'Deployment succeeded' }
failure {
echo 'Deployment failed, creating backup...'
sh 'sfdx force:mdapi:retrieve -k manifest/package.xml -r ./backup || true'
}
}
}




#!groovy
import groovy.json.JsonSlurperClassic
node {
    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH

    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploye Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

			println rc
			
			// need to pull out assigned username
			if (isUnix()) {
				rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d manifest/. -u ${HUB_ORG}"
			}else{
			   rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy -d manifest/. -u ${HUB_ORG}"
			}
			  
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}

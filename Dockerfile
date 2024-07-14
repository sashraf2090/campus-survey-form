# Use a base image with Java already installed
FROM tomcat:latest

# Copy the WAR file from your local machine to the container
COPY SurveyForm.war /usr/local/tomcat/webapps/


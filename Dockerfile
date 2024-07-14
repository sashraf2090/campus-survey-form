# Use a base image with Java already installed
FROM tomcat:latest

# Copy the WAR file from your local machine to the container
COPY SurveyForm.war /usr/local/tomcat/webapps/

# Expose the port that your application listens on
EXPOSE 8080

# Command to run when the container starts
CMD ["java", "-jar", "SurveyForm.war"]

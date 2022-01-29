FROM openjdk:11 as base
WORKDIR /app
COPY . .
#to run give gradle permission, otherwise it will give permission error
RUN chmod +x gradlew
RUN ./gradlew build

FROM tomcat:9
WORKDIR webapps
#sampleweb-0.0.1-SNAPSHOT.war folder name we got it from build.gradle
COPY --from=base /app/build/libs/sampleWeb-0.0.1-SNAPSHOT.war .
#remove the default root director rcursively and forcefully
RUN rm -rf ROOT   
#rename the war file in ROOT.war
RUN mv sampleWeb-0.0.1-SNAPSHOT.war ROOT.war


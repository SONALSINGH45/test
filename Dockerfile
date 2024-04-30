# Use the official Node.js image as the base image
FROM node:18.18.0 as build

# Set environment variables
ARG USERPOOL_ID
ARG COGNITO_IDENTITY_POOL_ID
ARG COGNITO_CLIENT_ID
ARG AWS_REGION
ARG ACCESSKEY_ID
ARG SECRET_ACCESS_KEY
ENV USERPOOL_ID=$USERPOOL_ID
ENV COGNITO_IDENTITY_POOL_ID=$COGNITO_IDENTITY_POOL_ID 
ENV COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID 
ENV AWS_REGION=$AWS_REGION 
ENV ACCESSKEY_ID=$ACCESSKEY_ID 
ENV SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json package-lock.json ./

# Install dependencies using npm
RUN npm install

# Copy the rest of the application files
COPY . ./

# Build the application
RUN npm run build

# Start a new stage of the Dockerfile
FROM node:18.18.0

# Set environment variables
ENV USERPOOL_ID=$USERPOOL_ID
ENV COGNITO_IDENTITY_POOL_ID=$COGNITO_IDENTITY_POOL_ID 
ENV COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID 
ENV AWS_REGION=$AWS_REGION 
ENV ACCESSKEY_ID=$ACCESSKEY_ID 
ENV SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY

# Set the working directory in the container
WORKDIR /app

# Copy package.json to the container
COPY package.json .

# Install production dependencies using npm
RUN npm install --production

# Copy the built application from the previous stage to the container
COPY --from=build /app/dist/ ./dist/

# Define the command to run when the container starts
CMD npm run start:prod

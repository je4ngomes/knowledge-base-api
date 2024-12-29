FROM n8nio/n8n:latest

# Switch to root user to install packages
USER root

COPY ./db/migrations /db/migrations

# Install Python3 and pip
RUN apk add --update --no-cache python3 py3-pip

# Upgrade pip and install the google-cloud-aiplatform package
RUN pip install --break-system-packages google-cloud-aiplatform

# Switch back to the default user (if needed)
USER node

# Set environment variables for n8n
ENV NODE_ENV=production
ENV N8N_PORT=5678

# Expose the port n8n will run on
EXPOSE 5678

# Start n8n
CMD ["n8n"]
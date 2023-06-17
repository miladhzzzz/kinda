FROM alpine:latest

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

# Expose the Kubernetes API server
EXPOSE 6443

# Start the Kubernetes API server
CMD ["./entrypoint.sh"]
FROM flyway/flyway:9.22.3-alpine

COPY ./sql /flyway/sql
WORKDIR /flyway

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD flyway info || exit 1

ENTRYPOINT ["flyway"]
CMD ["info"]

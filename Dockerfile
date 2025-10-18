# Build stage
FROM quay.io/keycloak/keycloak:latest as builder
ENV KC_DB=postgres
WORKDIR /opt/keycloak

# Pre-build optimized server
RUN /opt/keycloak/bin/kc.sh build

# Final stage
FROM quay.io/keycloak/keycloak:26.0.5
COPY --from=builder /opt/keycloak/ /opt/keycloak/
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]


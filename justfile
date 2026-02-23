# License file path
license := "connect-license.lic"

# Run integration tests against a local Connect instance in Docker
integration-tests connect_version="release":
    @command -v with-connect >/dev/null || { echo "Error: with-connect not found. Install it with: uv tool install git+https://github.com/posit-dev/with-connect.git"; exit 1; }
    @test -f {{ license }} || { echo "Error: {{ license }} not found. Place a valid Connect .lic file at the repo root."; exit 1; }
    Rscript -e 'devtools::install(quick = TRUE, upgrade = "never")'
    R_ENVIRON_USER='' \
    CONNECTAPI_INTEGRATED=true \
    DOCKER_DEFAULT_PLATFORM=linux/amd64 \
    with-connect \
        --license {{ license }} \
        --version {{ connect_version }} \
        -- Rscript -e 'source("tests/test-integrated.R")'

# Run unit tests (no Connect server required)
unit-tests:
    Rscript -e 'devtools::test()'

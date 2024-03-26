FROM eoshep/manylinux_2_28 as build
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

COPY ./ ./
RUN cmake -Bbuild -DCMAKE_INSTALL_PREFIX=install || true
RUN cmake --build build --config Release
RUN cmake --install build

# Do a test run
RUN ./build/piper_phonemize --help

# Build .tar.gz to keep symlinks
WORKDIR /dist
RUN mkdir -p piper_phonemize && \
  cp -dR /build/install/* ./piper_phonemize/ && \
  tar -czf "piper-phonemize_${TARGETARCH}${TARGETVARIANT}.tar.gz" piper_phonemize/

# -----------------------------------------------------------------------------

FROM scratch

COPY --from=build /dist/piper-phonemize_*.tar.gz ./

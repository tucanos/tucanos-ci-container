FROM alpine:3.18.0 as build
RUN apk add ninja cmake curl gcc musl-dev
RUN mkdir /build && cd /build \
 && curl -Ls https://github.com/LoicMarechal/libMeshb/archive/refs/tags/v7.60.tar.gz | tar xz \
 && cd libMeshb* \
 && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/local \
 && ninja install \
 && rm -rf /build
RUN mkdir /build && cd /build \
 && curl -Ls https://github.com/LoicMarechal/libOL/archive/976b9b2.tar.gz | tar xz \
 && cd libOL* \
 && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/local \
 && ninja install \
 && rm -rf /build
FROM build as final
RUN apk add python3 git clang-dev lapack-dev
COPY --from=build /usr/local/ /usr/local/

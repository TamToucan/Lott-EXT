#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
[[ -z $1 ]] && echo "$0 <dir for deps" && exit 1
SCRIPT_DIR="$1"
DEPS_ROOT="${SCRIPT_DIR}/deps"
BUILD_DIR="${DEPS_ROOT}/build_temp"
CUTE_SRC="${DEPS_ROOT}/cute_source"
CUTE_INSTALL="${DEPS_ROOT}/cute"

echo "[My Build] Setting up dependencies in: ${DEPS_ROOT}"

# --- 1. Prepare Directories ---
mkdir -p "${DEPS_ROOT}"

# --- 2. Clone Cute Framework (If missing) ---
if [ ! -d "${CUTE_SRC}" ]; then
    echo "[My Build] Cloning cute_framework..."
    git clone --depth 1 https://github.com/RandyGaul/cute_framework.git "${CUTE_SRC}"
else
    echo "[My Build] cute_framework source already exists."
fi

# --- 3. Configure CMake ---
echo "[My Build] Configuring Cute Framework..."

# We added -march=native to C and CXX flags to fix the SSE4.1/smmintrin.h error
cmake -S "${CUTE_SRC}" -B "${BUILD_DIR}" -G "MinGW Makefiles" \
    -DCMAKE_INSTALL_PREFIX="${CUTE_INSTALL}" \
    -DCMAKE_C_FLAGS="-march=native" \
    -DCMAKE_CXX_FLAGS="-march=native" \
    -DCF_FRAMEWORK_STATIC=ON \
    -DSDL_SHARED=OFF \
    -DSDL_STATIC=ON \
    -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON \
    -DCF_CUTE_SHADERC=OFF \
    -DCF_RUNTIME_SHADER_COMPILATION=OFF \
    -DCF_FRAMEWORK_BUILD_SAMPLES=OFF \
    -DCF_FRAMEWORK_BUILD_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=Release

# --- 4. Build and Install ---
echo "[My Build] Building..."
cmake --build "${BUILD_DIR}" --config Release --parallel 4

echo "[My Build] Installing headers and libs..."
cmake --install "${BUILD_DIR}" \
&& cp -R "${CUTE_SRC}/include" ${CUTE_INSTALL} \
&& cp -R "${CUTE_SRC}/libraries/cute" ${CUTE_INSTALL}

# --- 5. Cleanup ---
echo "[My Build] Cleaning up temp build artifacts..."
rm -rf "${BUILD_DIR}"

echo "[My Build] Success! Cute Framework installed to ${CUTE_INSTALL}"


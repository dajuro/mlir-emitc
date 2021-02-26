// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// This file defines functions emitted by TosaToEmitC

#ifndef EMITC_EMITC_TOSA_H
#define EMITC_EMITC_TOSA_H

#include "emitc_core_ops.h"

namespace tosa {

/// Unary elementwise ops
// AbsOp
template <typename Src>
inline Src abs(Src x) {
  return emitc::abs<Src>(x);
}

// CeilOp
template <typename Src>
inline Src ceil(Src x) {
  return emitc::ceil<Src>(x);
}

// ExpOp
template <typename Src>
inline Src exp(Src x) {
  return emitc::exp<Src>(x);
}

// FloorOp
template <typename Src>
inline Src floor(Src x) {
  return emitc::floor<Src>(x);
}

// LogOp
template <typename Src>
inline Src log(Src x) {
  return emitc::log<Src>(x);
}

// ReciprocalOp
template <typename Src>
inline Src reciprocal(Src x) {
  using ET_Src = typename get_element_type<Src>::type;

  auto f = [](ET_Src element) { return (static_cast<ET_Src>(1.0) / element); };

  return unary<Src>(x, f);
}

// TanhOp
template <typename Src>
inline Src tanh(Src x) {
  return emitc::tanh<Src>(x);
}

/// Binary elementwise ops
// AddOp
template <typename Src>
inline Src add(Src x, Src y) {
  return emitc::add<Src>(x, y);
}

// MulOp
template <typename Src>
inline Src mul(Src x, Src y) {
  return emitc::mul(x, y);
}

template <typename Src, IsTensorOfType<Src, int32_t> = true>
inline Src mul(Src x, Src y, const int32_t shift) {
  // Adopted from
  // https://git.mlplatform.org/tosa/reference_model.git/tree/reference_model/src/ops/ewise_binary.cc?id=df8626976df6c779bb30df9c5ceef689462109c0#n436
  if (shift > 0) {
    auto f = [&shift](int32_t x, int32_t y) -> int32_t {
      int64_t result;
      int64_t round = 1L << (shift - 1);
      result = x * y + round;
      result = result >> shift;
      return static_cast<int32_t>(result);
    };
    return binary<Src>(x, y, f);
  } else {
    return emitc::mul(x, y);
  }
}

/// Other ops
// Conv2DOp
template <typename Dest, typename Src, typename Weights>
Dest conv2D(Src input, Weights weights, Tensor1D<int64_t, 4> padding,
            Tensor1D<int64_t, 2> stride, Tensor1D<int64_t, 2> dilation) {
  static_assert(is_tensor_of_dim<4, Src>::value,
                "Expected 4 dimensional input");
  static_assert(is_tensor_of_dim<4, Dest>::value,
                "Expected 4 dimensional output");
  static_assert(is_tensor_of_dim<4, Weights>::value,
                "Expected 4 dimensional weights");

  assert(stride[0] == 1);
  assert(stride[0] == 1);

  assert(dilation[0] == 1);
  assert(dilation[0] == 1);

  const int N = input.dim(0);
  const int H_IN = input.dim(1);
  const int W_IN = input.dim(2);
  const int C_IN = input.dim(3);

  Dest output;

  const int C_OUT = output.dim(0);
  const int K_H = weights.dim(1);
  const int K_W = weights.dim(2);

  const int G_OUT = C_OUT;

  const int S_H = stride[0];
  const int S_W = stride[1];

  const int pt = padding[0];
  const int pb = padding[1];
  const int pl = padding[2];
  const int pr = padding[3];

  const int H_PAD = pt + H_IN + pb;
  const int W_PAD = pl + W_IN + pr;

  const int feature_group_count = 1;
  const int G_IN = C_IN / feature_group_count;

  // Convolution
  for (int n = 0; n < N; n++) {
    for (int h_pad = 0; h_pad < H_PAD - K_H + 1; h_pad += S_H) {
      for (int w_pad = 0; w_pad < W_PAD - K_W + 1; w_pad += S_W) {
        for (int kh = 0; kh < K_H; kh++) {
          for (int kw = 0; kw < K_W; kw++) {
            for (int g = 0; g < feature_group_count; g++) {
              for (int g_in = 0; g_in < G_IN; g_in++) {
                for (int g_out = 0; g_out < G_OUT; g_out++) {
                  const int h_out = h_pad / S_H;
                  const int w_out = w_pad / S_W;
                  const int c_out = g * G_OUT + g_out;
                  const int h_in = h_pad - pt + kh;
                  const int w_in = w_pad - pl + kw;
                  const int c_in = g * G_IN + g_in;

                  if (h_in < 0 || h_in >= H_IN || w_in < 0 || w_in >= W_IN)
                    continue;

                  output(n, h_out, w_out, c_out) +=
                      input(n, h_in, w_in, c_in) * weights(c_out, kh, kw, c_in);
                }
              }
            }
          }
        }
      }
    }
  }

  return output;
}

// FullyConnectedOp
template <typename Dest, typename Src, typename Weights, typename Bias>
Dest fully_connected(Src input, Weights weights, Bias bias) {
  static_assert(is_tensor_of_dim<2, Src>::value,
                "Expected 2 dimensional input");
  static_assert(is_tensor_of_dim<2, Dest>::value,
                "Expected 2 dimensional output");
  static_assert(is_tensor_of_dim<2, Weights>::value,
                "Expected 2 dimensional weights");
  static_assert(is_tensor_of_dim<1, Bias>::value,
                "Expected 1 dimensional bias");

  Dest output;
  static_assert(input.dim(0) == output.dim(0),
                "Output and input batch dimension do not match.");
  static_assert(input.dim(1) == weights.dim(1),
                "Input and weights dimensions do not match.");
  static_assert(output.dim(1) == weights.dim(0),
                "Output and weights dimensions do not match.");
  static_assert(weights.dim(0) == bias.dim(0),
                "Bias and weights dimensions do not match.");

  const size_t N = input.dim(0);
  const size_t C_IN = input.dim(1);
  const size_t C_OUT = weights.dim(0);

  for (size_t n = 0; n < N; ++n) {
    for (size_t c_out = 0; c_out < C_OUT; ++c_out) {
      for (size_t c_in = 0; c_in < C_IN; ++c_in) {
        auto in = input(n, c_in);
        auto weight = weights(c_out, c_in);
        output(n, c_out) += in * weight;
      }
      output(n, c_out) += bias(c_out);
    }
  }
  return output;
}

} // namespace tosa

#endif // EMITC_EMITC_TOSA_H

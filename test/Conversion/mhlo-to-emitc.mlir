// RUN: emitc-opt -convert-mhlo-to-emitc %s | FileCheck %s

func @float_abs(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::abs"
  %0 = "mhlo.abs"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_bitcast_convert(%arg0: tensor<ui32>) -> tensor<i32> {
  // CHECK: emitc.call "mhlo::bitcast_convert"(%arg0) {template_args = [i32]}
  %0 = "mhlo.bitcast_convert"(%arg0) : (tensor<ui32>) -> tensor<i32>
  return %0 : tensor<i32>
}

func @mhlo_broadcast_in_dim(%arg0: tensor<i32>) -> tensor<3xi32> {
  // CHECK: emitc.call "mhlo::broadcast_in_dim"(%arg0) {template_args = [3 : i32]}
  %0 = "mhlo.broadcast_in_dim"(%arg0) {broadcast_dimensions = dense<> : tensor<0xi64>}: (tensor<i32>) -> tensor<3xi32>
  return %0 : tensor<3xi32>
}

func @mhlo_compare(%arg0: tensor<4xi32>, %arg1: tensor<4xi32>) -> tensor<4xi1> {
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::less"]}
  %0 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "LT"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::less_equal"]}
  %1 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "LE"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::greater"]}
  %2 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "GT"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::greater_equal"]}
  %3 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "GE"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::equal_to"]}
  %4 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "EQ"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  // CHECK: emitc.call "mhlo::compare"(%arg0, %arg1) {template_args = [i32, "std::not_equal_to"]}
  %5 = "mhlo.compare"(%arg0, %arg1) {comparison_direction = "NE"} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
  
  return %0 : tensor<4xi1>
}

func @mhlo_convert(%arg0: tensor<ui32>) -> tensor<ui64> {
  // CHECK: emitc.call "mhlo::convert"(%arg0) {template_args = [ui64]}
  %0 = "mhlo.convert"(%arg0) : (tensor<ui32>) -> tensor<ui64>
  return %0 : tensor<ui64>
}

func @mhlo_cos(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::cos"
  %0 = "mhlo.cosine"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_exponential(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::exponential"
  %0 = "mhlo.exponential"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_is_finite(%arg0: tensor<4xf32>) -> tensor<4xi1> {
  // CHECK: emitc.call "mhlo::isfinite"
  %0 = "mhlo.is_finite"(%arg0) : (tensor<4xf32>) -> tensor<4xi1>
  return %0 : tensor<4xi1>
}

func @mhlo_log(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::log"
  %0 = "mhlo.log"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_negate(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::negate"
  %0 = "mhlo.negate"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_reshape(%arg0: tensor<12xf32>) -> tensor<2x3x2xf32> {
  // CHECK: emitc.call "mhlo::reshape"(%arg0)
  %0 = "mhlo.reshape"(%arg0) : (tensor<12xf32>) -> tensor<2x3x2xf32>
  return %0 : tensor<2x3x2xf32>
}

func @mhlo_sine(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::sin"
  %0 = "mhlo.sine"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_select(%arg0: tensor<2xf32>, %arg1: tensor<2xf32>, %arg2: tensor<2xi1>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::select"(%arg2, %arg0, %arg1)
  %1 = "mhlo.select"(%arg2, %arg0, %arg1) : (tensor<2xi1>, tensor<2xf32>, tensor<2xf32>) -> tensor<2xf32>
  return %1 : tensor<2xf32>
}

func @mhlo_sqrt(%arg0: tensor<2xf32>) -> tensor<2xf32> {
  // CHECK: emitc.call "mhlo::sqrt"
  %0 = "mhlo.sqrt"(%arg0) : (tensor<2xf32>) -> tensor<2xf32>
  return %0 : tensor<2xf32>
}

func @mhlo_add_i64(%arg0: tensor<i64>) -> tensor<i64> {
  // CHECK: emitc.call "mhlo::add"
  %0 = mhlo.add %arg0, %arg0 : tensor<i64>
  return %0 : tensor<i64>
}

func @mhlo_add_f64(%arg0: tensor<f64>) -> tensor<f64> {
  // CHECK: emitc.call "mhlo::add"
  %0 = mhlo.add %arg0, %arg0 : tensor<f64>
  return %0 : tensor<f64>
}

func @mhlo_divide(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::div"
  %0 = "mhlo.divide"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_max(%arg0: tensor<4xf32>, %arg1: tensor<4xf32>) -> tensor<4xf32> {
  // CHECK: emitc.call "mhlo::max"
  %0 = "mhlo.maximum"(%arg0, %arg0) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
  return %0 : tensor<4xf32>
}

func @mhlo_min(%arg0: tensor<4xf32>, %arg1: tensor<4xf32>) -> tensor<4xf32> {
  // CHECK: emitc.call "mhlo::min"
  %0 = "mhlo.minimum"(%arg0, %arg0) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
  return %0 : tensor<4xf32>
}

func @mhlo_multiply(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::mul"
  %0 = "mhlo.multiply"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_power(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::pow"
  %0 = "mhlo.power"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_shift_left(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::shift_left"
  %0 = "mhlo.shift_left"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_shift_right_logical(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::shift_right_logical"
  %0 = "mhlo.shift_right_logical"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_sub(%arg0: tensor<f32>) -> tensor<f32> {
  // CHECK: emitc.call "mhlo::sub"
  %0 = "mhlo.subtract"(%arg0, %arg0) : (tensor<f32>, tensor<f32>) -> tensor<f32>
  return %0 : tensor<f32>
}

func @mhlo_or(%arg0: tensor<ui64>, %arg1: tensor<ui64>) -> tensor<ui64> {
  // CHECK: emitc.call "mhlo::or"
  %0 = "mhlo.or"(%arg0, %arg1) : (tensor<ui64>, tensor<ui64>) -> tensor<ui64>
  return %0 : tensor<ui64>
}

func @mhlo_xor(%arg0: tensor<ui64>, %arg1: tensor<ui64>) -> tensor<ui64> {
  // CHECK: emitc.call "mhlo::xor"
  %0 = "mhlo.xor"(%arg0, %arg1) : (tensor<ui64>, tensor<ui64>) -> tensor<ui64>
  return %0 : tensor<ui64>
}

func @mhlo_tuple(%arg0: tensor<i32>, %arg1: tensor<ui64>) -> (tuple<tensor<i32>, tensor<ui64>, tensor<i32>, tensor<ui64>>) {
  // CHECK: emitc.call "std::make_tuple"()
  %0 = "mhlo.tuple"() : () -> tuple<>
  // CHECK: emitc.call "std::make_tuple"(%arg0)
  %1 = "mhlo.tuple"(%arg0) : (tensor<i32>) -> tuple<tensor<i32>>
  // CHECK: emitc.call "std::make_tuple"(%arg0, %arg1)
  %2 = "mhlo.tuple"(%arg0, %arg1) : (tensor<i32>, tensor<ui64>) -> tuple<tensor<i32>, tensor<ui64>>
  // CHECK: emitc.call "std::make_tuple"(%arg0, %arg1, %arg0, %arg1)
  %3 = "mhlo.tuple"(%arg0, %arg1, %arg0, %arg1) : (tensor<i32>, tensor<ui64>, tensor<i32>, tensor<ui64>) -> tuple<tensor<i32>, tensor<ui64>, tensor<i32>, tensor<ui64>>
  return %3 : tuple<tensor<i32>, tensor<ui64>, tensor<i32>, tensor<ui64>>
}

func @mhlo_tuple_nested(%arg0: tensor<i32>, %arg1: tensor<ui64>) -> tuple<tensor<i32>, tuple<tensor<i32>, tensor<ui64>>> {
  %0 = "mhlo.tuple"(%arg0, %arg1) : (tensor<i32>, tensor<ui64>) -> tuple<tensor<i32>, tensor<ui64>>
  %1 = "mhlo.tuple"(%arg0, %0) : (tensor<i32>, tuple<tensor<i32>, tensor<ui64>>) -> tuple<tensor<i32>, tuple<tensor<i32>, tensor<ui64>>>
  return %1 : tuple<tensor<i32>, tuple<tensor<i32>, tensor<ui64>>>
}

func @mhlo_tuple_unpack(%arg0: tensor<i32>, %arg1: tensor<ui64>) -> (tuple<tensor<i32>, tensor<ui64>>, tensor<i32>) {
  %0 = call @mhlo_tuple_nested(%arg0, %arg1) : (tensor<i32>, tensor<ui64>) -> tuple<tensor<i32>, tuple<tensor<i32>, tensor<ui64>>>
  // CHECK: emitc.call "std::get"(%0) {template_args = [1 : i32]}
  %1 = "mhlo.get_tuple_element"(%0) {index = 1 : i32} : (tuple<tensor<i32>, tuple<tensor<i32>, tensor<ui64>>>) -> tuple<tensor<i32>, tensor<ui64>>
  // CHECK: emitc.call "std::get"(%1) {template_args = [0 : i32]}
  %2 = "mhlo.get_tuple_element"(%1) {index = 0 : i32} : (tuple<tensor<i32>, tensor<ui64>>) -> tensor<i32>
  return %1, %2 : tuple<tensor<i32>, tensor<ui64>>, tensor<i32>
}

func @mhlo_concaternate(%arg0: tensor<1xf32>, %arg1: tensor<2xf32>) -> tensor<3xf32> {
  // CHECK: emitc.call "mhlo::concatenate"
  %0 = "mhlo.concatenate"(%arg0, %arg1) {dimension = 0 : i64} : (tensor<1xf32>, tensor<2xf32>) -> tensor<3xf32>
  return %0 : tensor<3xf32>
}

func @mhlo_slice(%arg0: tensor<12xi32>, %arg1: tensor<8x7xi32>) -> tensor<4x3xi32> {
  // CHECK: emitc.call "mhlo::slice"(%arg0) {template_args = [i32, 0, 1, 1, 12, 1]}
  %0 = "mhlo.slice"(%arg0) {limit_indices = dense<1> : tensor<1xi64>, start_indices = dense<0> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>} : (tensor<12xi32>) -> tensor<1xi32>
  // CHECK: emitc.call "mhlo::slice"(%arg1) {template_args = [i32, 0, 0, 4, 3, 1, 1, 8, 7, 4, 3]}
  %1 = "mhlo.slice"(%arg1) {limit_indices = dense<[4, 3]> : tensor<2xi64>, start_indices = dense<0> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} : (tensor<8x7xi32>) -> tensor<4x3xi32>    
  return %1 : tensor<4x3xi32>
}

func @mhlo_dynamic_slice(%arg0: tensor<12xi32>, %arg1: tensor<8x7xi32>) -> () {
  %cst = "std.constant"() {value = dense<1> : tensor<i64>} : () -> tensor<i64>
  %cst_0 = "std.constant"() {value = dense<3> : tensor<i64>} : () -> tensor<i64>
  // CHECK: emitc.call "mhlo::dynamic_slice"(%arg0, %cst) {template_args = [i32, 4, 12, 4]}
  %0 = "mhlo.dynamic-slice"(%arg0, %cst) {slice_sizes = dense<4> : tensor<1xi64>} : (tensor<12xi32>, tensor<i64>) -> tensor<4xi32>
  // CHECK: emitc.call "mhlo::dynamic_slice"(%arg1, %cst, %cst_0) {template_args = [i32, 4, 2, 8, 7, 4, 2]}
  %1 = "mhlo.dynamic-slice"(%arg1, %cst, %cst_0) {slice_sizes = dense<[4, 2]> : tensor<2xi64>} : (tensor<8x7xi32>, tensor<i64>, tensor<i64>) -> tensor<4x2xi32>
  return
}

func @mhlo_dynamic_update_slice(%arg0: tensor<12xi32>, %arg1: tensor<8x7xi32>) -> () {
  %cst = "std.constant"() {value = dense<1> : tensor<i64>} : () -> tensor<i64>
  %cst_0 = "std.constant"() {value = dense<3> : tensor<i64>} : () -> tensor<i64>
  %cst_1 = "std.constant"() {value = dense<1> : tensor<4xi32>} : () -> tensor<4xi32>
  %cst_2 = "std.constant"() {value = dense<1> : tensor<2x4xi32>} : () -> tensor<2x4xi32>
  // CHECK: emitc.call "mhlo::dynamic_update_slice"(%arg0, %cst_1, %cst) {template_args = [i32, 12, 4]}
  %0 = "mhlo.dynamic-update-slice"(%arg0, %cst_1, %cst) : (tensor<12xi32>, tensor<4xi32>, tensor<i64>) -> tensor<12xi32>
  // CHECK: emitc.call "mhlo::dynamic_update_slice"(%arg1, %cst_2, %cst, %cst_0) {template_args = [i32, 8, 7, 2, 4]}
  %1 = "mhlo.dynamic-update-slice"(%arg1, %cst_2, %cst, %cst_0) : (tensor<8x7xi32>, tensor<2x4xi32>, tensor<i64>, tensor<i64>) -> tensor<8x7xi32>
  return
}

func @mhlo_rng_uniform() -> () {
  %cst = "std.constant"() {value = dense<-100> : tensor<i32>} : () -> tensor<i32>
  %cst_0 = "std.constant"() {value = dense<100> : tensor<i32>} : () -> tensor<i32>
  %cst_1 = "std.constant"() {value = dense<2> : tensor<1xi64>} : () -> tensor<1xi64>

  // CHECK: emitc.call "mhlo::rng_uniform"(%cst, %cst_0, %cst_1) {template_args = [i32]}
  %0 = "mhlo.rng_uniform"(%cst, %cst_0, %cst_1) : (tensor<i32>, tensor<i32>, tensor<1xi64>) -> tensor<2xi32>
  
  %cst_2 = "std.constant"() {value = dense<-100.0> : tensor<f32>} : () -> tensor<f32>
  %cst_3 = "std.constant"() {value = dense<100.0> : tensor<f32>} : () -> tensor<f32>
  %cst_4 = "std.constant"() {value = dense<17> : tensor<1xi64>} : () -> tensor<1xi64>

  // CHECK: emitc.call "mhlo::rng_uniform"(%cst_2, %cst_3, %cst_4) {template_args = [f32]}
  %1 = "mhlo.rng_uniform"(%cst_2, %cst_3, %cst_4) : (tensor<f32>, tensor<f32>, tensor<1xi64>) -> tensor<17xf32>

  return
}

func @mhlo_rng_bit_generator() -> () {
  %cst = "std.constant"() {value = dense<2> : tensor<3xui64>} : () -> tensor<3xui64>

  // CHECK: emitc.call "mhlo::rng_bit_generator"(%cst) {template_args = [ui32, 2 : i32, 4]}
  %0 = "mhlo.rng_bit_generator"(%cst) {rng_algorithm = 2 : i32} : (tensor<3xui64>) -> tuple<tensor<3xui64>, tensor<2x2xui32>>
  
  // CHECK: emitc.call "mhlo::rng_bit_generator"(%cst) {template_args = [f64, 2 : i32, 42]}
  %1 = "mhlo.rng_bit_generator"(%cst) {rng_algorithm = 2 : i32} : (tensor<3xui64>) -> tuple<tensor<3xui64>, tensor<2x7x3xf64>>

  return
}
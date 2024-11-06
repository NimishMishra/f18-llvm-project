 // RUN: mlir-translate -mlir-to-llvmir %s | FileCheck %s

 omp.declare_reduction @add_reduction_i32 : i32 init {
  ^bb0(%arg0: i32):
    %0 = llvm.mlir.constant(0 : i32) : i32
    omp.yield(%0 : i32)
  } combiner {
  ^bb0(%arg0: i32, %arg1: i32):
    %0 = llvm.add %arg0, %arg1 : i32
    omp.yield(%0 : i32)
  }
  llvm.func @_QPtest_inreduction() {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.alloca %0 x i32 {bindc_name = "x", pinned} : (i64) -> !llvm.ptr
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.alloca %2 x i32 {bindc_name = "x"} : (i64) -> !llvm.ptr
    %4 = llvm.mlir.constant(0 : i32) : i32
    llvm.store %4, %3 : i32, !llvm.ptr
    %5 = llvm.load %3 : !llvm.ptr -> i32
    llvm.store %5, %1 : i32, !llvm.ptr
    omp.task in_reduction(@add_reduction_i32 %3 -> %arg0 : !llvm.ptr) {
      %6 = llvm.load %arg0 : !llvm.ptr -> i32
      %7 = llvm.mlir.constant(1 : i32) : i32
      %8 = llvm.add %6, %7 : i32
      llvm.store %8, %arg0 : i32, !llvm.ptr
      omp.terminator
    }
    llvm.return
  }

//CHECK-LABEL: define void @_QPtest_inreduction() {
//CHECK:         %[[STRUCTARG:.*]] = alloca { i32, ptr }, align 8
//CHECK:         %[[VAL1:.*]] = alloca i32, i64 1, align 4
//CHECK:         %[[VAL2:.*]] = alloca i32, i64 1, align 4
//CHECK:         store i32 0, ptr %[[VAL2]], align 4
//CHECK:         %[[VAL3:.*]] = load i32, ptr %[[VAL2]], align 4
//CHECK:         store i32 %[[VAL3]], ptr %[[VAL1]], align 4
//CHECK:         br label %entry

//CHECK: entry:
//CHECK:   %[[TID:.*]] = call i32 @__kmpc_global_thread_num(ptr @{{.*}})
//CHECK:   br label %codeRepl

//CHECK: codeRepl: 
//CHECK:   %[[TID2:.*]] = getelementptr { i32, ptr }, ptr %[[STRUCTARG]], i32 0, i32 0
//CHECK:   store i32 %[[TID]], ptr %[[TID2]], align 4
//CHECK:   %[[VAL4:.*]] = getelementptr { i32, ptr }, ptr %[[STRUCTARG]], i32 0, i32 1
//CHECK:   store ptr %[[VAL2]], ptr %[[VAL4]], align 8
//CHECK:   %[[TID3:.*]] = call i32 @__kmpc_global_thread_num(ptr @{{.*}})
//CHECK:   %[[VAL5:.*]] = call ptr @__kmpc_omp_task_alloc(ptr @1, i32 %[[TID3]], i32 1, i64 40, i64 16, ptr @_QPtest_inreduction..omp_par)
//CHECK:   %[[VAL6:.*]] = load ptr, ptr %[[VAL5]], align 8
//CHECK:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %[[VAL6]], ptr align 1 %[[STRUCTARG]], i64 16, i1 false)
//CHECK:   %[[VAL7:.*]] = call i32 @__kmpc_omp_task(ptr @1, i32 %[[TID3]], ptr %[[VAL5]])
//CHECK:   br label %task.exit

//CHECK: task.exit:
//CHECK:   ret void
//CHECK: }

//CHECK-LABEL: define internal void @_QPtest_inreduction..omp_par(i32 %{{.*}}, ptr %{{.*}}) {
//CHECK:       task.alloca:
//CHECK:         %[[VAL9:.*]] = load ptr, ptr %{{.*}}, align 8
//CHECK:         %[[TID4:.*]] = getelementptr { i32, ptr }, ptr %[[VAL9]], i32 0, i32 0
//CHECK:         %[[VAL10:.*]] = load i32, ptr %[[TID4]], align 4
//CHECK:         %[[VAL11:.*]] = getelementptr { i32, ptr }, ptr %[[VAL9]], i32 0, i32 1
//CHECK:         %[[VAL12:.*]] = load ptr, ptr %[[VAL11]], align 8
//CHECK:         br label %task.body

//CHECK:       task.body:
//CHECK:         %[[VAL13:.*]] = call ptr @__kmpc_task_reduction_get_th_data(i32 %[[VAL10]], ptr null, ptr %[[VAL12]])
//CHECK:         br label %omp.task.region

//CHECK:       omp.task.region:
//CHECK:         %[[VAL14:.*]] = load i32, ptr %[[VAL13]], align 4
//CHECK:         %[[VAL15:.*]] = add i32 %[[VAL14]], 1
//CHECK:         store i32 %[[VAL15]], ptr %[[VAL13]], align 4
//CHECK:         br label %omp.region.cont

//CHECK:       omp.region.cont:
//CHECK:         br label %task.exit.exitStub

//CHECK:       task.exit.exitStub: 
//CHECK:         ret void
//CHECK: }

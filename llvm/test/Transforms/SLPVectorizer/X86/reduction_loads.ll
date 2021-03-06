; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -S -mtriple=x86_64-apple-macosx10.10.0 -mattr=+sse4.2 | FileCheck %s

; PR28474

;void foo();
;
;int test1(unsigned int *p) {
;  int sum = 0;
;  #pragma nounroll
;  for (int y = 0; y < 2; y++) {
;    // Inner loop gets unrolled
;    for (int x = 0; x < 8; x++) {
;      sum += p[x] * 42;
;    }
;    // Dummy call to keep outer loop alive
;    foo();
;  }
;  return sum;
;}

define i32 @test(i32* nocapture readonly %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[OP_EXTRA:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[P]] to <8 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i32>, <8 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = mul <8 x i32> [[TMP1]], <i32 42, i32 42, i32 42, i32 42, i32 42, i32 42, i32 42, i32 42>
; CHECK-NEXT:    [[ADD:%.*]] = add i32 undef, [[SUM]]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 undef, [[ADD]]
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 undef, [[ADD_1]]
; CHECK-NEXT:    [[ADD_3:%.*]] = add i32 undef, [[ADD_2]]
; CHECK-NEXT:    [[ADD_4:%.*]] = add i32 undef, [[ADD_3]]
; CHECK-NEXT:    [[ADD_5:%.*]] = add i32 undef, [[ADD_4]]
; CHECK-NEXT:    [[ADD_6:%.*]] = add i32 undef, [[ADD_5]]
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <8 x i32> [[TMP2]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <8 x i32> [[BIN_RDX]], <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX2:%.*]] = add <8 x i32> [[BIN_RDX]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[RDX_SHUF3:%.*]] = shufflevector <8 x i32> [[BIN_RDX2]], <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX4:%.*]] = add <8 x i32> [[BIN_RDX2]], [[RDX_SHUF3]]
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <8 x i32> [[BIN_RDX4]], i32 0
; CHECK-NEXT:    [[OP_EXTRA]] = add i32 [[TMP3]], [[SUM]]
; CHECK-NEXT:    [[ADD_7:%.*]] = add i32 undef, [[ADD_6]]
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 [[OP_EXTRA]]
;
entry:
  %arrayidx.1 = getelementptr inbounds i32, i32* %p, i64 1
  %arrayidx.2 = getelementptr inbounds i32, i32* %p, i64 2
  %arrayidx.3 = getelementptr inbounds i32, i32* %p, i64 3
  %arrayidx.4 = getelementptr inbounds i32, i32* %p, i64 4
  %arrayidx.5 = getelementptr inbounds i32, i32* %p, i64 5
  %arrayidx.6 = getelementptr inbounds i32, i32* %p, i64 6
  %arrayidx.7 = getelementptr inbounds i32, i32* %p, i64 7
  br label %for.body

for.body:
  %sum = phi i32 [ 0, %entry ], [ %add.7, %for.body ]
  %tmp = load i32, i32* %p, align 4
  %mul = mul i32 %tmp, 42
  %add = add i32 %mul, %sum
  %tmp5 = load i32, i32* %arrayidx.1, align 4
  %mul.1 = mul i32 %tmp5, 42
  %add.1 = add i32 %mul.1, %add
  %tmp6 = load i32, i32* %arrayidx.2, align 4
  %mul.2 = mul i32 %tmp6, 42
  %add.2 = add i32 %mul.2, %add.1
  %tmp7 = load i32, i32* %arrayidx.3, align 4
  %mul.3 = mul i32 %tmp7, 42
  %add.3 = add i32 %mul.3, %add.2
  %tmp8 = load i32, i32* %arrayidx.4, align 4
  %mul.4 = mul i32 %tmp8, 42
  %add.4 = add i32 %mul.4, %add.3
  %tmp9 = load i32, i32* %arrayidx.5, align 4
  %mul.5 = mul i32 %tmp9, 42
  %add.5 = add i32 %mul.5, %add.4
  %tmp10 = load i32, i32* %arrayidx.6, align 4
  %mul.6 = mul i32 %tmp10, 42
  %add.6 = add i32 %mul.6, %add.5
  %tmp11 = load i32, i32* %arrayidx.7, align 4
  %mul.7 = mul i32 %tmp11, 42
  %add.7 = add i32 %mul.7, %add.6
  br i1 true, label %for.end, label %for.body

for.end:
  ret i32 %add.7
}

;void foo();
;
;int test2(unsigned int *p, unsigned int *q) {
;  int sum = 0;
;  #pragma nounroll
;  for (int y = 0; y < 2; y++) {
;    // Inner loop gets unrolled
;    for (int x = 0; x < 8; x++) {
;      sum += p[x] * q[x];
;    }
;    // Dummy call to keep outer loop alive
;    foo();
;  }
;  return sum;
;}

define i32 @test2(i32* nocapture readonly %p, i32* nocapture readonly %q) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX_P_1:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_P_2:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_P_3:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_P_4:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_P_5:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_P_6:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_P_7:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    [[ARRAYIDX_Q_1:%.*]] = getelementptr inbounds i32, i32* [[Q:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_Q_2:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_Q_3:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_Q_4:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_Q_5:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_Q_6:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_Q_7:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 7
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[OP_EXTRA:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[P]] to <8 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i32>, <8 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[Q]] to <8 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <8 x i32>, <8 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = mul <8 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[ADD:%.*]] = add i32 undef, [[SUM]]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 undef, [[ADD]]
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 undef, [[ADD_1]]
; CHECK-NEXT:    [[ADD_3:%.*]] = add i32 undef, [[ADD_2]]
; CHECK-NEXT:    [[ADD_4:%.*]] = add i32 undef, [[ADD_3]]
; CHECK-NEXT:    [[ADD_5:%.*]] = add i32 undef, [[ADD_4]]
; CHECK-NEXT:    [[ADD_6:%.*]] = add i32 undef, [[ADD_5]]
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <8 x i32> [[TMP4]], <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <8 x i32> [[TMP4]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <8 x i32> [[BIN_RDX]], <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX2:%.*]] = add <8 x i32> [[BIN_RDX]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[RDX_SHUF3:%.*]] = shufflevector <8 x i32> [[BIN_RDX2]], <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX4:%.*]] = add <8 x i32> [[BIN_RDX2]], [[RDX_SHUF3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x i32> [[BIN_RDX4]], i32 0
; CHECK-NEXT:    [[OP_EXTRA]] = add i32 [[TMP5]], [[SUM]]
; CHECK-NEXT:    [[ADD_7:%.*]] = add i32 undef, [[ADD_6]]
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 [[OP_EXTRA]]
;
entry:
  %arrayidx.p.1 = getelementptr inbounds i32, i32* %p, i64 1
  %arrayidx.p.2 = getelementptr inbounds i32, i32* %p, i64 2
  %arrayidx.p.3 = getelementptr inbounds i32, i32* %p, i64 3
  %arrayidx.p.4 = getelementptr inbounds i32, i32* %p, i64 4
  %arrayidx.p.5 = getelementptr inbounds i32, i32* %p, i64 5
  %arrayidx.p.6 = getelementptr inbounds i32, i32* %p, i64 6
  %arrayidx.p.7 = getelementptr inbounds i32, i32* %p, i64 7

  %arrayidx.q.1 = getelementptr inbounds i32, i32* %q, i64 1
  %arrayidx.q.2 = getelementptr inbounds i32, i32* %q, i64 2
  %arrayidx.q.3 = getelementptr inbounds i32, i32* %q, i64 3
  %arrayidx.q.4 = getelementptr inbounds i32, i32* %q, i64 4
  %arrayidx.q.5 = getelementptr inbounds i32, i32* %q, i64 5
  %arrayidx.q.6 = getelementptr inbounds i32, i32* %q, i64 6
  %arrayidx.q.7 = getelementptr inbounds i32, i32* %q, i64 7
  br label %for.body

for.body:
  %sum = phi i32 [ 0, %entry ], [ %add.7, %for.body ]
  %tmpp = load i32, i32* %p, align 4
  %tmpq = load i32, i32* %q, align 4
  %mul = mul i32 %tmpp, %tmpq
  %add = add i32 %mul, %sum
  %tmp5p = load i32, i32* %arrayidx.p.1, align 4
  %tmp5q = load i32, i32* %arrayidx.q.1, align 4
  %mul.1 = mul i32 %tmp5p, %tmp5q
  %add.1 = add i32 %mul.1, %add
  %tmp6p = load i32, i32* %arrayidx.p.2, align 4
  %tmp6q = load i32, i32* %arrayidx.q.2, align 4
  %mul.2 = mul i32 %tmp6p, %tmp6q
  %add.2 = add i32 %mul.2, %add.1
  %tmp7p = load i32, i32* %arrayidx.p.3, align 4
  %tmp7q = load i32, i32* %arrayidx.q.3, align 4
  %mul.3 = mul i32 %tmp7p, %tmp7q
  %add.3 = add i32 %mul.3, %add.2
  %tmp8p = load i32, i32* %arrayidx.p.4, align 4
  %tmp8q = load i32, i32* %arrayidx.q.4, align 4
  %mul.4 = mul i32 %tmp8p, %tmp8q
  %add.4 = add i32 %mul.4, %add.3
  %tmp9p = load i32, i32* %arrayidx.p.5, align 4
  %tmp9q = load i32, i32* %arrayidx.q.5, align 4
  %mul.5 = mul i32 %tmp9p, %tmp9q
  %add.5 = add i32 %mul.5, %add.4
  %tmp10p = load i32, i32* %arrayidx.p.6, align 4
  %tmp10q = load i32, i32* %arrayidx.q.6, align 4
  %mul.6 = mul i32 %tmp10p, %tmp10q
  %add.6 = add i32 %mul.6, %add.5
  %tmp11p = load i32, i32* %arrayidx.p.7, align 4
  %tmp11q = load i32, i32* %arrayidx.q.7, align 4
  %mul.7 = mul i32 %tmp11p, %tmp11q
  %add.7 = add i32 %mul.7, %add.6
  br i1 true, label %for.end, label %for.body

for.end:
  ret i32 %add.7
}

;void foo();
;
;int test3(unsigned int *p, unsigned int *q) {
;  int sum = 0;
;  #pragma nounroll
;  for (int y = 0; y < 2; y++) {
;    // Inner loop gets unrolled
;    for (int x = 0; x < 8; x++) {
;      sum += p[x] * q[7-x];
;    }
;    // Dummy call to keep outer loop alive
;    foo();
;  }
;  return sum;
;}

define i32 @test3(i32* nocapture readonly %p, i32* nocapture readonly %q) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX_P_1:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_P_2:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_P_3:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_P_4:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_P_5:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_P_6:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_P_7:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    [[ARRAYIDX_Q_1:%.*]] = getelementptr inbounds i32, i32* [[Q:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX_Q_2:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 2
; CHECK-NEXT:    [[ARRAYIDX_Q_3:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 3
; CHECK-NEXT:    [[ARRAYIDX_Q_4:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 4
; CHECK-NEXT:    [[ARRAYIDX_Q_5:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 5
; CHECK-NEXT:    [[ARRAYIDX_Q_6:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 6
; CHECK-NEXT:    [[ARRAYIDX_Q_7:%.*]] = getelementptr inbounds i32, i32* [[Q]], i64 7
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[SUM:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[OP_EXTRA:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[P]] to <8 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i32>, <8 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[REORDER_SHUFFLE:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[Q]] to <8 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <8 x i32>, <8 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = mul <8 x i32> [[REORDER_SHUFFLE]], [[TMP3]]
; CHECK-NEXT:    [[ADD:%.*]] = add i32 undef, [[SUM]]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 undef, [[ADD]]
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 undef, [[ADD_1]]
; CHECK-NEXT:    [[ADD_3:%.*]] = add i32 undef, [[ADD_2]]
; CHECK-NEXT:    [[ADD_4:%.*]] = add i32 undef, [[ADD_3]]
; CHECK-NEXT:    [[ADD_5:%.*]] = add i32 undef, [[ADD_4]]
; CHECK-NEXT:    [[ADD_6:%.*]] = add i32 undef, [[ADD_5]]
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <8 x i32> [[TMP4]], <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <8 x i32> [[TMP4]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <8 x i32> [[BIN_RDX]], <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX2:%.*]] = add <8 x i32> [[BIN_RDX]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[RDX_SHUF3:%.*]] = shufflevector <8 x i32> [[BIN_RDX2]], <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX4:%.*]] = add <8 x i32> [[BIN_RDX2]], [[RDX_SHUF3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x i32> [[BIN_RDX4]], i32 0
; CHECK-NEXT:    [[OP_EXTRA]] = add i32 [[TMP5]], [[SUM]]
; CHECK-NEXT:    [[ADD_7:%.*]] = add i32 undef, [[ADD_6]]
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 [[OP_EXTRA]]
;
entry:
  %arrayidx.p.1 = getelementptr inbounds i32, i32* %p, i64 1
  %arrayidx.p.2 = getelementptr inbounds i32, i32* %p, i64 2
  %arrayidx.p.3 = getelementptr inbounds i32, i32* %p, i64 3
  %arrayidx.p.4 = getelementptr inbounds i32, i32* %p, i64 4
  %arrayidx.p.5 = getelementptr inbounds i32, i32* %p, i64 5
  %arrayidx.p.6 = getelementptr inbounds i32, i32* %p, i64 6
  %arrayidx.p.7 = getelementptr inbounds i32, i32* %p, i64 7

  %arrayidx.q.1 = getelementptr inbounds i32, i32* %q, i64 1
  %arrayidx.q.2 = getelementptr inbounds i32, i32* %q, i64 2
  %arrayidx.q.3 = getelementptr inbounds i32, i32* %q, i64 3
  %arrayidx.q.4 = getelementptr inbounds i32, i32* %q, i64 4
  %arrayidx.q.5 = getelementptr inbounds i32, i32* %q, i64 5
  %arrayidx.q.6 = getelementptr inbounds i32, i32* %q, i64 6
  %arrayidx.q.7 = getelementptr inbounds i32, i32* %q, i64 7
  br label %for.body

for.body:
  %sum = phi i32 [ 0, %entry ], [ %add.7, %for.body ]
  %tmpp = load i32, i32* %p, align 4
  %tmpq = load i32, i32* %arrayidx.q.7, align 4
  %mul = mul i32 %tmpp, %tmpq
  %add = add i32 %mul, %sum
  %tmp5p = load i32, i32* %arrayidx.p.1, align 4
  %tmp5q = load i32, i32* %arrayidx.q.6, align 4
  %mul.1 = mul i32 %tmp5p, %tmp5q
  %add.1 = add i32 %mul.1, %add
  %tmp6p = load i32, i32* %arrayidx.p.2, align 4
  %tmp6q = load i32, i32* %arrayidx.q.5, align 4
  %mul.2 = mul i32 %tmp6p, %tmp6q
  %add.2 = add i32 %mul.2, %add.1
  %tmp7p = load i32, i32* %arrayidx.p.3, align 4
  %tmp7q = load i32, i32* %arrayidx.q.4, align 4
  %mul.3 = mul i32 %tmp7p, %tmp7q
  %add.3 = add i32 %mul.3, %add.2
  %tmp8p = load i32, i32* %arrayidx.p.4, align 4
  %tmp8q = load i32, i32* %arrayidx.q.3, align 4
  %mul.4 = mul i32 %tmp8p, %tmp8q
  %add.4 = add i32 %mul.4, %add.3
  %tmp9p = load i32, i32* %arrayidx.p.5, align 4
  %tmp9q = load i32, i32* %arrayidx.q.2, align 4
  %mul.5 = mul i32 %tmp9p, %tmp9q
  %add.5 = add i32 %mul.5, %add.4
  %tmp10p = load i32, i32* %arrayidx.p.6, align 4
  %tmp10q = load i32, i32* %arrayidx.q.1, align 4
  %mul.6 = mul i32 %tmp10p, %tmp10q
  %add.6 = add i32 %mul.6, %add.5
  %tmp11p = load i32, i32* %arrayidx.p.7, align 4
  %tmp11q = load i32, i32* %q, align 4
  %mul.7 = mul i32 %tmp11p, %tmp11q
  %add.7 = add i32 %mul.7, %add.6
  br i1 true, label %for.end, label %for.body

for.end:
  ret i32 %add.7
}

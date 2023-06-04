; ModuleID = 'main'
source_filename = "main"

@.str0 = private unnamed_addr global [3 x i8] c"%c\00"
@.str1 = private unnamed_addr global [2 x i8] c"\0A\00"
@arr = common global [90000 x i8] zeroinitializer
@arr.1 = common global [90000 x i8] zeroinitializer
@arr.2 = common global [300 x i32] zeroinitializer
@arr.3 = common global [300 x i32] zeroinitializer
@arr.4 = common global [300 x i1] zeroinitializer
@arr.5 = common global [300 x i1] zeroinitializer
@arr.6 = common global [300 x i8] zeroinitializer
@.str2 = private unnamed_addr global [3 x i8] c"%c\00"
@.str3 = private unnamed_addr global [13 x i8] c"GPA: %1.1lf\0A\00"
@.str4 = private unnamed_addr global [21 x i8] c"Hours Attempted: %d\0A\00"
@.str5 = private unnamed_addr global [21 x i8] c"Hours Completed: %d\0A\00"
@.str6 = private unnamed_addr global [23 x i8] c"Credits Remaining: %d\0A\00"
@arr.7 = common global [90000 x i32] zeroinitializer
@arr.8 = common global [300 x i8] zeroinitializer
@arr.9 = common global [10 x i32] zeroinitializer
@.str7 = private unnamed_addr global [32 x i8] c"\0APossible Courses to Take Next\0A\00"
@.str8 = private unnamed_addr global [3 x i8] c"  \00"
@.str9 = private unnamed_addr global [3 x i8] c"  \00"
@.str10 = private unnamed_addr global [27 x i8] c"  None - Congratulations!\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @scanf(i8*, ...)

declare i32 @gets(...)

define i32 @main() {
entry:
  %ch = alloca i8, align 1
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %countor = alloca i32, align 4
  %hourAttempted = alloca i32, align 4
  store i32 0, i32* %hourAttempted, align 4
  %hourCompleted = alloca i32, align 4
  store i32 0, i32* %hourCompleted, align 4
  %remaining = alloca i32, align 4
  store i32 0, i32* %remaining, align 4
  %total = alloca i32, align 4
  store i32 0, i32* %total, align 4
  %curGrade = alloca i32, align 4
  store i32 -1, i32* %curGrade, align 4
  %tmp = alloca i32, align 4
  %res = alloca i32, align 4
  %james = alloca i32, align 4
  store i32 0, i32* %james, align 4
  %index1 = alloca i32, align 4
  br label %doWhileLoop

doWhileLoop:                                      ; preds = %doWhileCond, %entry
  store i32 0, i32* %index1, align 4
  store i32 0, i32* %countor, align 4
  br label %doWhileLoop1

doWhileCond:                                      ; preds = %afterIf41
  %load167 = load i32, i32* %res, align 4
  %GT168 = icmp sgt i32 %load167, 0
  %0 = icmp ne i1 %GT168, false
  br i1 %0, label %doWhileLoop, label %afterDoWhile

afterDoWhile:                                     ; preds = %doWhileCond
  %n = alloca i32, align 4
  %load169 = load i32, i32* %i, align 4
  store i32 %load169, i32* %n, align 4
  %gpa = alloca double, align 8
  store double 0.000000e+00, double* %gpa, align 8
  %load170 = load i32, i32* %hourAttempted, align 4
  %1 = icmp ne i32 %load170, 0
  br i1 %1, label %then171, label %afterIf172

doWhileLoop1:                                     ; preds = %doWhileCond2, %doWhileLoop
  %call = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str2, i32 0, i32 0), i8* %ch)
  store i32 %call, i32* %res, align 4
  %load = load i8, i8* %ch, align 1
  %EQ = icmp eq i8 %load, 124
  %2 = icmp ne i1 %EQ, false
  br i1 %2, label %then, label %afterIf

doWhileCond2:                                     ; preds = %afterIf11
  %load25 = load i32, i32* %res, align 4
  %GT26 = icmp sgt i32 %load25, 0
  %load27 = load i8, i8* %ch, align 1
  %NE28 = icmp ne i8 %load27, 0
  %load29 = load i8, i8* %ch, align 1
  %NE30 = icmp ne i8 %load29, 10
  %AND31 = and i1 %NE28, %NE30
  %load32 = load i8, i8* %ch, align 1
  %EQ33 = icmp eq i8 %load32, 10
  %load34 = load i32, i32* %countor, align 4
  %LT35 = icmp slt i32 %load34, 3
  %AND36 = and i1 %EQ33, %LT35
  %OR = or i1 %AND31, %AND36
  %AND37 = and i1 %GT26, %OR
  %3 = icmp ne i1 %AND37, false
  br i1 %3, label %doWhileLoop1, label %afterDoWhile3

afterDoWhile3:                                    ; preds = %doWhileCond2
  %load38 = load i32, i32* %index1, align 4
  %GT39 = icmp sgt i32 %load38, 0
  %4 = icmp ne i1 %GT39, false
  br i1 %4, label %then40, label %afterIf41

then:                                             ; preds = %doWhileLoop1
  %load4 = load i32, i32* %countor, align 4
  %TINC = add i32 1, %load4
  store i32 %TINC, i32* %countor, align 4
  br label %afterIf

afterIf:                                          ; preds = %then, %doWhileLoop1
  %load5 = load i32, i32* %res, align 4
  %GT = icmp sgt i32 %load5, 0
  %load6 = load i8, i8* %ch, align 1
  %NE = icmp ne i8 %load6, 0
  %AND = and i1 %GT, %NE
  %load7 = load i8, i8* %ch, align 1
  %NE8 = icmp ne i8 %load7, 10
  %AND9 = and i1 %AND, %NE8
  %5 = icmp ne i1 %AND9, false
  br i1 %5, label %then10, label %else

then10:                                           ; preds = %afterIf
  %load12 = load i8, i8* %ch, align 1
  %load13 = load i32, i32* %index1, align 4
  %elementPtr = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load13
  store i8 %load12, i8* %elementPtr, align 4
  %load14 = load i32, i32* %index1, align 4
  %TINC15 = add i32 1, %load14
  store i32 %TINC15, i32* %index1, align 4
  br label %afterIf11

else:                                             ; preds = %afterIf
  %load16 = load i32, i32* %countor, align 4
  %LT = icmp slt i32 %load16, 3
  %load17 = load i8, i8* %ch, align 1
  %EQ18 = icmp eq i8 %load17, 10
  %AND19 = and i1 %LT, %EQ18
  %6 = icmp ne i1 %AND19, false
  br i1 %6, label %then20, label %else21

afterIf11:                                        ; preds = %afterIf22, %then10
  br label %doWhileCond2

then20:                                           ; preds = %else
  br label %afterIf22

else21:                                           ; preds = %else
  %load23 = load i32, i32* %index1, align 4
  %elementPtr24 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load23
  store i8 0, i8* %elementPtr24, align 4
  br label %afterIf22

afterIf22:                                        ; preds = %else21, %then20
  br label %afterIf11

then40:                                           ; preds = %afterDoWhile3
  store i32 0, i32* %j, align 4
  store i32 0, i32* %k, align 4
  br label %whileCond

afterIf41:                                        ; preds = %afterIf142, %afterDoWhile3
  br label %doWhileCond

whileLoop:                                        ; preds = %whileCond
  %load42 = load i32, i32* %j, align 4
  %elementPtr43 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load42
  %7 = load i8, i8* %elementPtr43, align 4
  %load44 = load i32, i32* %k, align 4
  %load45 = load i32, i32* %i, align 4
  %MUL = mul i32 300, %load45
  %PLUS = add i32 %load44, %MUL
  %elementPtr46 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i32 %PLUS
  store i8 %7, i8* %elementPtr46, align 4
  %load47 = load i32, i32* %k, align 4
  %TINC48 = add i32 1, %load47
  store i32 %TINC48, i32* %k, align 4
  %load49 = load i32, i32* %j, align 4
  %TINC50 = add i32 1, %load49
  store i32 %TINC50, i32* %j, align 4
  br label %whileCond

whileCond:                                        ; preds = %whileLoop, %then40
  %load51 = load i32, i32* %j, align 4
  %elementPtr52 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load51
  %8 = load i8, i8* %elementPtr52, align 4
  %NE53 = icmp ne i8 %8, 124
  %9 = icmp ne i1 %NE53, false
  br i1 %9, label %whileLoop, label %afterWhile

afterWhile:                                       ; preds = %whileCond
  %load54 = load i32, i32* %k, align 4
  %load55 = load i32, i32* %i, align 4
  %MUL56 = mul i32 300, %load55
  %PLUS57 = add i32 %load54, %MUL56
  %elementPtr58 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i32 %PLUS57
  store i8 0, i8* %elementPtr58, align 4
  %load59 = load i32, i32* %j, align 4
  %TINC60 = add i32 1, %load59
  store i32 %TINC60, i32* %j, align 4
  store i32 0, i32* %tmp, align 4
  br label %whileCond62

whileLoop61:                                      ; preds = %whileCond62
  %load64 = load i32, i32* %tmp, align 4
  %MUL65 = mul i32 %load64, 10
  store i32 %MUL65, i32* %tmp, align 4
  %load66 = load i32, i32* %tmp, align 4
  %load67 = load i32, i32* %j, align 4
  %elementPtr68 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load67
  %10 = load i8, i8* %elementPtr68, align 4
  %11 = sext i8 %10 to i32
  %PLUS69 = add i32 %load66, %11
  %MINUS = sub i32 %PLUS69, 48
  store i32 %MINUS, i32* %tmp, align 4
  %load70 = load i32, i32* %j, align 4
  %TINC71 = add i32 1, %load70
  store i32 %TINC71, i32* %j, align 4
  br label %whileCond62

whileCond62:                                      ; preds = %whileLoop61, %afterWhile
  %load72 = load i32, i32* %j, align 4
  %elementPtr73 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load72
  %12 = load i8, i8* %elementPtr73, align 4
  %NE74 = icmp ne i8 %12, 124
  %13 = icmp ne i1 %NE74, false
  br i1 %13, label %whileLoop61, label %afterWhile63

afterWhile63:                                     ; preds = %whileCond62
  %load75 = load i32, i32* %j, align 4
  %TINC76 = add i32 1, %load75
  store i32 %TINC76, i32* %j, align 4
  %load77 = load i32, i32* %tmp, align 4
  %load78 = load i32, i32* %i, align 4
  %elementPtr79 = getelementptr inbounds i32, i32* getelementptr inbounds ([300 x i32], [300 x i32]* @arr.2, i32 0, i32 0), i32 %load78
  store i32 %load77, i32* %elementPtr79, align 4
  store i32 0, i32* %k, align 4
  br label %whileCond81

whileLoop80:                                      ; preds = %whileCond81
  %load83 = load i32, i32* %j, align 4
  %elementPtr84 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load83
  %14 = load i8, i8* %elementPtr84, align 4
  %load85 = load i32, i32* %k, align 4
  %load86 = load i32, i32* %i, align 4
  %MUL87 = mul i32 300, %load86
  %PLUS88 = add i32 %load85, %MUL87
  %elementPtr89 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS88
  store i8 %14, i8* %elementPtr89, align 4
  %load90 = load i32, i32* %k, align 4
  %TINC91 = add i32 1, %load90
  store i32 %TINC91, i32* %k, align 4
  %load92 = load i32, i32* %j, align 4
  %TINC93 = add i32 1, %load92
  store i32 %TINC93, i32* %j, align 4
  br label %whileCond81

whileCond81:                                      ; preds = %whileLoop80, %afterWhile63
  %load94 = load i32, i32* %j, align 4
  %elementPtr95 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load94
  %15 = load i8, i8* %elementPtr95, align 4
  %NE96 = icmp ne i8 %15, 124
  %16 = icmp ne i1 %NE96, false
  br i1 %16, label %whileLoop80, label %afterWhile82

afterWhile82:                                     ; preds = %whileCond81
  %load97 = load i32, i32* %i, align 4
  %MUL98 = mul i32 300, %load97
  %PLUS99 = add i32 0, %MUL98
  %elementPtr100 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS99
  %17 = load i8, i8* %elementPtr100, align 4
  %NE101 = icmp ne i8 %17, 0
  %18 = icmp ne i1 %NE101, false
  br i1 %18, label %then102, label %afterIf103

then102:                                          ; preds = %afterWhile82
  %load104 = load i32, i32* %i, align 4
  %elementPtr105 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.5, i32 0, i32 0), i32 %load104
  store i1 true, i1* %elementPtr105, align 4
  br label %afterIf103

afterIf103:                                       ; preds = %then102, %afterWhile82
  %load106 = load i32, i32* %k, align 4
  %load107 = load i32, i32* %i, align 4
  %MUL108 = mul i32 300, %load107
  %PLUS109 = add i32 %load106, %MUL108
  %elementPtr110 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS109
  store i8 0, i8* %elementPtr110, align 4
  %load111 = load i32, i32* %j, align 4
  %TINC112 = add i32 1, %load111
  store i32 %TINC112, i32* %j, align 4
  %load113 = load i32, i32* %j, align 4
  %elementPtr114 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load113
  %19 = load i8, i8* %elementPtr114, align 4
  %EQ115 = icmp eq i8 %19, 0
  %20 = icmp ne i1 %EQ115, false
  br i1 %20, label %then116, label %else117

then116:                                          ; preds = %afterIf103
  store i32 -1, i32* %curGrade, align 4
  %load119 = load i32, i32* %i, align 4
  %elementPtr120 = getelementptr inbounds i32, i32* getelementptr inbounds ([300 x i32], [300 x i32]* @arr.3, i32 0, i32 0), i32 %load119
  store i32 -1, i32* %elementPtr120, align 4
  br label %afterIf118

else117:                                          ; preds = %afterIf103
  %load121 = load i32, i32* %j, align 4
  %elementPtr122 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load121
  %21 = load i8, i8* %elementPtr122, align 4
  %NE123 = icmp ne i8 %21, 70
  %22 = icmp ne i1 %NE123, false
  br i1 %22, label %then124, label %else125

afterIf118:                                       ; preds = %afterIf126, %then116
  %load139 = load i32, i32* %curGrade, align 4
  %GE = icmp sge i32 %load139, 0
  %23 = icmp ne i1 %GE, false
  br i1 %23, label %then140, label %else141

then124:                                          ; preds = %else117
  %load127 = load i32, i32* %i, align 4
  %elementPtr128 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.4, i32 0, i32 0), i32 %load127
  store i1 true, i1* %elementPtr128, align 4
  %load129 = load i32, i32* %j, align 4
  %elementPtr130 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.6, i32 0, i32 0), i32 %load129
  %24 = load i8, i8* %elementPtr130, align 4
  %MINUS131 = sub i8 65, %24
  %25 = sext i8 %MINUS131 to i32
  %PLUS132 = add i32 %25, 4
  store i32 %PLUS132, i32* %curGrade, align 4
  %load133 = load i32, i32* %curGrade, align 4
  %load134 = load i32, i32* %i, align 4
  %elementPtr135 = getelementptr inbounds i32, i32* getelementptr inbounds ([300 x i32], [300 x i32]* @arr.3, i32 0, i32 0), i32 %load134
  store i32 %load133, i32* %elementPtr135, align 4
  br label %afterIf126

else125:                                          ; preds = %else117
  store i32 0, i32* %curGrade, align 4
  %load136 = load i32, i32* %curGrade, align 4
  %load137 = load i32, i32* %i, align 4
  %elementPtr138 = getelementptr inbounds i32, i32* getelementptr inbounds ([300 x i32], [300 x i32]* @arr.3, i32 0, i32 0), i32 %load137
  store i32 %load136, i32* %elementPtr138, align 4
  br label %afterIf126

afterIf126:                                       ; preds = %else125, %then124
  br label %afterIf118

then140:                                          ; preds = %afterIf118
  %load143 = load i32, i32* %hourAttempted, align 4
  %load144 = load i32, i32* %tmp, align 4
  %PLUS145 = add i32 %load143, %load144
  store i32 %PLUS145, i32* %hourAttempted, align 4
  %load146 = load i32, i32* %curGrade, align 4
  %GT147 = icmp sgt i32 %load146, 0
  %26 = icmp ne i1 %GT147, false
  br i1 %26, label %then148, label %else149

else141:                                          ; preds = %afterIf118
  %load162 = load i32, i32* %remaining, align 4
  %load163 = load i32, i32* %tmp, align 4
  %PLUS164 = add i32 %load162, %load163
  store i32 %PLUS164, i32* %remaining, align 4
  br label %afterIf142

afterIf142:                                       ; preds = %else141, %afterIf150
  %load165 = load i32, i32* %i, align 4
  %TINC166 = add i32 1, %load165
  store i32 %TINC166, i32* %i, align 4
  br label %afterIf41

then148:                                          ; preds = %then140
  %load151 = load i32, i32* %hourCompleted, align 4
  %load152 = load i32, i32* %tmp, align 4
  %PLUS153 = add i32 %load151, %load152
  store i32 %PLUS153, i32* %hourCompleted, align 4
  %load154 = load i32, i32* %total, align 4
  %load155 = load i32, i32* %tmp, align 4
  %load156 = load i32, i32* %curGrade, align 4
  %MUL157 = mul i32 %load155, %load156
  %PLUS158 = add i32 %load154, %MUL157
  store i32 %PLUS158, i32* %total, align 4
  br label %afterIf150

else149:                                          ; preds = %then140
  %load159 = load i32, i32* %remaining, align 4
  %load160 = load i32, i32* %tmp, align 4
  %PLUS161 = add i32 %load159, %load160
  store i32 %PLUS161, i32* %remaining, align 4
  br label %afterIf150

afterIf150:                                       ; preds = %else149, %then148
  br label %afterIf142

then171:                                          ; preds = %afterDoWhile
  %load173 = load i32, i32* %total, align 4
  %FTMP = sitofp i32 %load173 to double
  %FMUL = fmul double %FTMP, 1.000000e+00
  %load174 = load i32, i32* %hourAttempted, align 4
  %FTMP175 = sitofp i32 %load174 to double
  %FDIV = fdiv double %FMUL, %FTMP175
  store double %FDIV, double* %gpa, align 8
  br label %afterIf172

afterIf172:                                       ; preds = %then171, %afterDoWhile
  %load176 = load double, double* %gpa, align 8
  %call177 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str3, i32 0, i32 0), double %load176)
  %load178 = load i32, i32* %hourAttempted, align 4
  %call179 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str4, i32 0, i32 0), i32 %load178)
  %load180 = load i32, i32* %hourCompleted, align 4
  %call181 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str5, i32 0, i32 0), i32 %load180)
  %load182 = load i32, i32* %remaining, align 4
  %call183 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str6, i32 0, i32 0), i32 %load182)
  %cur = alloca i32, align 4
  store i32 0, i32* %cur, align 4
  %curN = alloca i32, align 4
  store i32 0, i32* %curN, align 4
  %target = alloca i32, align 4
  %fast = alloca i1, align 1
  store i1 false, i1* %fast, align 1
  %offset = alloca i32, align 4
  store i32 0, i32* %offset, align 4
  store i32 0, i32* %i, align 4
  br label %forCon

forLoop:                                          ; preds = %forCon
  store i32 0, i32* %j, align 4
  store i32 0, i32* %k, align 4
  store i32 1, i32* %cur, align 4
  store i32 0, i32* %curN, align 4
  store i32 0, i32* %offset, align 4
  store i1 false, i1* %fast, align 1
  br label %whileCond185

forCon:                                           ; preds = %afterIf287, %afterIf172
  %load325 = load i32, i32* %i, align 4
  %load326 = load i32, i32* %n, align 4
  %LT327 = icmp slt i32 %load325, %load326
  %27 = icmp ne i1 %LT327, false
  br i1 %27, label %forLoop, label %afterFor

afterFor:                                         ; preds = %forCon
  %toTake = alloca i32, align 4
  store i32 0, i32* %toTake, align 4
  %sat = alloca i1, align 1
  store i1 true, i1* %sat, align 1
  %hasPreCur = alloca i1, align 1
  store i1 false, i1* %hasPreCur, align 1
  %call328 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str7, i32 0, i32 0))
  store i32 0, i32* %i, align 4
  br label %forCon330

whileLoop184:                                     ; preds = %whileCond185
  %load187 = load i32, i32* %j, align 4
  %load188 = load i32, i32* %i, align 4
  %MUL189 = mul i32 300, %load188
  %PLUS190 = add i32 %load187, %MUL189
  %elementPtr191 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS190
  %28 = load i8, i8* %elementPtr191, align 4
  %EQ192 = icmp eq i8 %28, 59
  %29 = icmp ne i1 %EQ192, false
  br i1 %29, label %then193, label %else194

whileCond185:                                     ; preds = %afterIf195, %forLoop
  %load278 = load i32, i32* %j, align 4
  %load279 = load i32, i32* %i, align 4
  %MUL280 = mul i32 300, %load279
  %PLUS281 = add i32 %load278, %MUL280
  %elementPtr282 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS281
  %30 = load i8, i8* %elementPtr282, align 4
  %NE283 = icmp ne i8 %30, 0
  %31 = icmp ne i1 %NE283, false
  br i1 %31, label %whileLoop184, label %afterWhile186

afterWhile186:                                    ; preds = %whileCond185
  %load284 = load i1, i1* %fast, align 1
  %NOT285 = xor i1 %load284, true
  %32 = icmp ne i1 %NOT285, false
  br i1 %32, label %then286, label %afterIf287

then193:                                          ; preds = %whileLoop184
  %load196 = load i1, i1* %fast, align 1
  %33 = icmp ne i1 %load196, false
  br i1 %33, label %then197, label %else198

else194:                                          ; preds = %whileLoop184
  %load242 = load i1, i1* %fast, align 1
  %NOT = xor i1 %load242, true
  %34 = icmp ne i1 %NOT, false
  br i1 %34, label %then243, label %afterIf244

afterIf195:                                       ; preds = %afterIf244, %afterIf241
  %load276 = load i32, i32* %j, align 4
  %TINC277 = add i32 1, %load276
  store i32 %TINC277, i32* %j, align 4
  br label %whileCond185

then197:                                          ; preds = %then193
  store i1 false, i1* %fast, align 1
  %load200 = load i32, i32* %cur, align 4
  %DIV = sdiv i32 %load200, 2
  store i32 %DIV, i32* %cur, align 4
  br label %afterIf199

else198:                                          ; preds = %then193
  %load201 = load i32, i32* %offset, align 4
  %elementPtr202 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load201
  store i8 0, i8* %elementPtr202, align 4
  store i32 0, i32* %offset, align 4
  %load203 = load i32, i32* %n, align 4
  %call204 = call i32 @find(i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load203)
  store i32 %call204, i32* %target, align 4
  %load205 = load i32, i32* %target, align 4
  %EQ206 = icmp eq i32 %load205, -1
  %35 = icmp ne i1 %EQ206, false
  br i1 %35, label %then207, label %else208

afterIf199:                                       ; preds = %afterFor216, %then197
  store i32 0, i32* %curN, align 4
  %load236 = load i32, i32* %cur, align 4
  %MUL237 = mul i32 %load236, 2
  store i32 %MUL237, i32* %cur, align 4
  %load238 = load i32, i32* %cur, align 4
  %EQ239 = icmp eq i32 %load238, 0
  %36 = icmp ne i1 %EQ239, false
  br i1 %36, label %then240, label %afterIf241

then207:                                          ; preds = %else198
  store i32 0, i32* %curN, align 4
  br label %afterIf209

else208:                                          ; preds = %else198
  %load210 = load i32, i32* %target, align 4
  %load211 = load i32, i32* %curN, align 4
  %TINC212 = add i32 1, %load211
  store i32 %TINC212, i32* %curN, align 4
  %elementPtr213 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load211
  store i32 %load210, i32* %elementPtr213, align 4
  br label %afterIf209

afterIf209:                                       ; preds = %else208, %then207
  store i32 0, i32* %k, align 4
  br label %forCon215

forLoop214:                                       ; preds = %forCon215
  %load217 = load i32, i32* %k, align 4
  %elementPtr218 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load217
  %37 = load i32, i32* %elementPtr218, align 4
  %load219 = load i32, i32* %i, align 4
  %MUL220 = mul i32 300, %load219
  %PLUS221 = add i32 %37, %MUL220
  %elementPtr222 = getelementptr inbounds i32, i32* getelementptr inbounds ([90000 x i32], [90000 x i32]* @arr.7, i32 0, i32 0), i32 %PLUS221
  %38 = load i32, i32* %elementPtr222, align 4
  %load223 = load i32, i32* %cur, align 4
  %PLUS224 = add i32 %38, %load223
  %load225 = load i32, i32* %k, align 4
  %elementPtr226 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load225
  %39 = load i32, i32* %elementPtr226, align 4
  %load227 = load i32, i32* %i, align 4
  %MUL228 = mul i32 300, %load227
  %PLUS229 = add i32 %39, %MUL228
  %elementPtr230 = getelementptr inbounds i32, i32* getelementptr inbounds ([90000 x i32], [90000 x i32]* @arr.7, i32 0, i32 0), i32 %PLUS229
  store i32 %PLUS224, i32* %elementPtr230, align 4
  %load231 = load i32, i32* %k, align 4
  %TINC232 = add i32 1, %load231
  store i32 %TINC232, i32* %k, align 4
  br label %forCon215

forCon215:                                        ; preds = %forLoop214, %afterIf209
  %load233 = load i32, i32* %k, align 4
  %load234 = load i32, i32* %curN, align 4
  %LT235 = icmp slt i32 %load233, %load234
  %40 = icmp ne i1 %LT235, false
  br i1 %40, label %forLoop214, label %afterFor216

afterFor216:                                      ; preds = %forCon215
  br label %afterIf199

then240:                                          ; preds = %afterIf199
  store i32 1, i32* %cur, align 4
  br label %afterIf241

afterIf241:                                       ; preds = %then240, %afterIf199
  br label %afterIf195

then243:                                          ; preds = %else194
  %load245 = load i32, i32* %j, align 4
  %load246 = load i32, i32* %i, align 4
  %MUL247 = mul i32 300, %load246
  %PLUS248 = add i32 %load245, %MUL247
  %elementPtr249 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS248
  %41 = load i8, i8* %elementPtr249, align 4
  %EQ250 = icmp eq i8 %41, 44
  %42 = icmp ne i1 %EQ250, false
  br i1 %42, label %then251, label %else252

afterIf244:                                       ; preds = %afterIf253, %else194
  br label %afterIf195

then251:                                          ; preds = %then243
  %load254 = load i32, i32* %offset, align 4
  %elementPtr255 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load254
  store i8 0, i8* %elementPtr255, align 4
  store i32 0, i32* %offset, align 4
  %load256 = load i32, i32* %n, align 4
  %call257 = call i32 @find(i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load256)
  store i32 %call257, i32* %target, align 4
  %load258 = load i32, i32* %target, align 4
  %EQ259 = icmp eq i32 %load258, -1
  %43 = icmp ne i1 %EQ259, false
  br i1 %43, label %then260, label %else261

else252:                                          ; preds = %then243
  %load267 = load i32, i32* %j, align 4
  %load268 = load i32, i32* %i, align 4
  %MUL269 = mul i32 300, %load268
  %PLUS270 = add i32 %load267, %MUL269
  %elementPtr271 = getelementptr inbounds i8, i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr.1, i32 0, i32 0), i32 %PLUS270
  %44 = load i8, i8* %elementPtr271, align 4
  %load272 = load i32, i32* %offset, align 4
  %elementPtr273 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load272
  store i8 %44, i8* %elementPtr273, align 4
  %load274 = load i32, i32* %offset, align 4
  %TINC275 = add i32 1, %load274
  store i32 %TINC275, i32* %offset, align 4
  br label %afterIf253

afterIf253:                                       ; preds = %else252, %afterIf262
  br label %afterIf244

then260:                                          ; preds = %then251
  store i1 true, i1* %fast, align 1
  br label %afterIf262

else261:                                          ; preds = %then251
  %load263 = load i32, i32* %target, align 4
  %load264 = load i32, i32* %curN, align 4
  %TINC265 = add i32 1, %load264
  store i32 %TINC265, i32* %curN, align 4
  %elementPtr266 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load264
  store i32 %load263, i32* %elementPtr266, align 4
  br label %afterIf262

afterIf262:                                       ; preds = %else261, %then260
  br label %afterIf253

then286:                                          ; preds = %afterWhile186
  %load288 = load i32, i32* %offset, align 4
  %elementPtr289 = getelementptr inbounds i8, i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load288
  store i8 0, i8* %elementPtr289, align 4
  store i32 0, i32* %offset, align 4
  %load290 = load i32, i32* %n, align 4
  %call291 = call i32 @find(i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i8* getelementptr inbounds ([300 x i8], [300 x i8]* @arr.8, i32 0, i32 0), i32 %load290)
  store i32 %call291, i32* %target, align 4
  %load292 = load i32, i32* %target, align 4
  %EQ293 = icmp eq i32 %load292, -1
  %45 = icmp ne i1 %EQ293, false
  br i1 %45, label %then294, label %else295

afterIf287:                                       ; preds = %afterFor303, %afterWhile186
  %load323 = load i32, i32* %i, align 4
  %TINC324 = add i32 1, %load323
  store i32 %TINC324, i32* %i, align 4
  br label %forCon

then294:                                          ; preds = %then286
  store i32 0, i32* %curN, align 4
  br label %afterIf296

else295:                                          ; preds = %then286
  %load297 = load i32, i32* %target, align 4
  %load298 = load i32, i32* %curN, align 4
  %TINC299 = add i32 1, %load298
  store i32 %TINC299, i32* %curN, align 4
  %elementPtr300 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load298
  store i32 %load297, i32* %elementPtr300, align 4
  br label %afterIf296

afterIf296:                                       ; preds = %else295, %then294
  store i32 0, i32* %k, align 4
  br label %forCon302

forLoop301:                                       ; preds = %forCon302
  %load304 = load i32, i32* %k, align 4
  %elementPtr305 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load304
  %46 = load i32, i32* %elementPtr305, align 4
  %load306 = load i32, i32* %i, align 4
  %MUL307 = mul i32 300, %load306
  %PLUS308 = add i32 %46, %MUL307
  %elementPtr309 = getelementptr inbounds i32, i32* getelementptr inbounds ([90000 x i32], [90000 x i32]* @arr.7, i32 0, i32 0), i32 %PLUS308
  %47 = load i32, i32* %elementPtr309, align 4
  %load310 = load i32, i32* %cur, align 4
  %PLUS311 = add i32 %47, %load310
  %load312 = load i32, i32* %k, align 4
  %elementPtr313 = getelementptr inbounds i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @arr.9, i32 0, i32 0), i32 %load312
  %48 = load i32, i32* %elementPtr313, align 4
  %load314 = load i32, i32* %i, align 4
  %MUL315 = mul i32 300, %load314
  %PLUS316 = add i32 %48, %MUL315
  %elementPtr317 = getelementptr inbounds i32, i32* getelementptr inbounds ([90000 x i32], [90000 x i32]* @arr.7, i32 0, i32 0), i32 %PLUS316
  store i32 %PLUS311, i32* %elementPtr317, align 4
  %load318 = load i32, i32* %k, align 4
  %TINC319 = add i32 1, %load318
  store i32 %TINC319, i32* %k, align 4
  br label %forCon302

forCon302:                                        ; preds = %forLoop301, %afterIf296
  %load320 = load i32, i32* %k, align 4
  %load321 = load i32, i32* %curN, align 4
  %LT322 = icmp slt i32 %load320, %load321
  %49 = icmp ne i1 %LT322, false
  br i1 %49, label %forLoop301, label %afterFor303

afterFor303:                                      ; preds = %forCon302
  br label %afterIf287

forLoop329:                                       ; preds = %forCon330
  store i1 false, i1* %hasPreCur, align 1
  store i32 1, i32* %j, align 4
  br label %forCon333

forCon330:                                        ; preds = %afterIf382, %afterFor
  %load389 = load i32, i32* %i, align 4
  %load390 = load i32, i32* %n, align 4
  %LT391 = icmp slt i32 %load389, %load390
  %50 = icmp ne i1 %LT391, false
  br i1 %50, label %forLoop329, label %afterFor331

afterFor331:                                      ; preds = %forCon330
  %load392 = load i32, i32* %toTake, align 4
  %EQ393 = icmp eq i32 %load392, 0
  %load394 = load i32, i32* %remaining, align 4
  %EQ395 = icmp eq i32 %load394, 0
  %AND396 = and i1 %EQ393, %EQ395
  %51 = icmp ne i1 %AND396, false
  br i1 %51, label %then397, label %afterIf398

forLoop332:                                       ; preds = %forCon333
  store i1 true, i1* %sat, align 1
  store i1 false, i1* %hasPreCur, align 1
  store i32 0, i32* %k, align 4
  br label %forCon336

forCon333:                                        ; preds = %afterIf366, %forLoop329
  %load373 = load i32, i32* %j, align 4
  %LE = icmp sle i32 %load373, 1024
  %52 = icmp ne i1 %LE, false
  br i1 %52, label %forLoop332, label %afterFor334

afterFor334:                                      ; preds = %forCon333, %then365
  %load374 = load i32, i32* %i, align 4
  %elementPtr375 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.5, i32 0, i32 0), i32 %load374
  %53 = load i1, i1* %elementPtr375, align 4
  %NOT376 = xor i1 %53, true
  %load377 = load i32, i32* %i, align 4
  %elementPtr378 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.4, i32 0, i32 0), i32 %load377
  %54 = load i1, i1* %elementPtr378, align 4
  %NOT379 = xor i1 %54, true
  %AND380 = and i1 %NOT376, %NOT379
  %55 = icmp ne i1 %AND380, false
  br i1 %55, label %then381, label %afterIf382

forLoop335:                                       ; preds = %forCon336
  %load338 = load i32, i32* %k, align 4
  %load339 = load i32, i32* %i, align 4
  %MUL340 = mul i32 300, %load339
  %PLUS341 = add i32 %load338, %MUL340
  %elementPtr342 = getelementptr inbounds i32, i32* getelementptr inbounds ([90000 x i32], [90000 x i32]* @arr.7, i32 0, i32 0), i32 %PLUS341
  %56 = load i32, i32* %elementPtr342, align 4
  %load343 = load i32, i32* %j, align 4
  %DIV344 = sdiv i32 %56, %load343
  %MOD = srem i32 %DIV344, 2
  %EQ345 = icmp eq i32 %MOD, 1
  %57 = icmp ne i1 %EQ345, false
  br i1 %57, label %then346, label %afterIf347

forCon336:                                        ; preds = %afterIf347, %forLoop332
  %load355 = load i32, i32* %k, align 4
  %load356 = load i32, i32* %n, align 4
  %LT357 = icmp slt i32 %load355, %load356
  %58 = icmp ne i1 %LT357, false
  br i1 %58, label %forLoop335, label %afterFor337

afterFor337:                                      ; preds = %forCon336
  %load358 = load i1, i1* %sat, align 1
  %load359 = load i1, i1* %hasPreCur, align 1
  %AND360 = and i1 %load358, %load359
  %load361 = load i32, i32* %i, align 4
  %elementPtr362 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.4, i32 0, i32 0), i32 %load361
  %59 = load i1, i1* %elementPtr362, align 4
  %NOT363 = xor i1 %59, true
  %AND364 = and i1 %AND360, %NOT363
  %60 = icmp ne i1 %AND364, false
  br i1 %60, label %then365, label %afterIf366

then346:                                          ; preds = %forLoop335
  store i1 true, i1* %hasPreCur, align 1
  %load348 = load i32, i32* %k, align 4
  %elementPtr349 = getelementptr inbounds i1, i1* getelementptr inbounds ([300 x i1], [300 x i1]* @arr.4, i32 0, i32 0), i32 %load348
  %61 = load i1, i1* %elementPtr349, align 4
  %NOT350 = xor i1 %61, true
  %62 = icmp ne i1 %NOT350, false
  br i1 %62, label %then351, label %afterIf352

afterIf347:                                       ; preds = %afterIf352, %forLoop335
  %load353 = load i32, i32* %k, align 4
  %TINC354 = add i32 1, %load353
  store i32 %TINC354, i32* %k, align 4
  br label %forCon336

then351:                                          ; preds = %then346
  store i1 false, i1* %sat, align 1
  br label %afterIf352

afterIf352:                                       ; preds = %then351, %then346
  br label %afterIf347

then365:                                          ; preds = %afterFor337
  %load367 = load i32, i32* %toTake, align 4
  %TINC368 = add i32 1, %load367
  store i32 %TINC368, i32* %toTake, align 4
  %call369 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str8, i32 0, i32 0))
  %load370 = load i32, i32* %i, align 4
  call void @prints(i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i32 %load370, i1 true)
  br label %afterFor334
  br label %afterIf366

afterIf366:                                       ; preds = %then365, %afterFor337
  %load371 = load i32, i32* %j, align 4
  %MUL372 = mul i32 %load371, 2
  store i32 %MUL372, i32* %j, align 4
  br label %forCon333

then381:                                          ; preds = %afterFor334
  %load383 = load i32, i32* %toTake, align 4
  %TINC384 = add i32 1, %load383
  store i32 %TINC384, i32* %toTake, align 4
  %call385 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str9, i32 0, i32 0))
  %load386 = load i32, i32* %i, align 4
  call void @prints(i8* getelementptr inbounds ([90000 x i8], [90000 x i8]* @arr, i32 0, i32 0), i32 %load386, i1 true)
  br label %afterIf382

afterIf382:                                       ; preds = %then381, %afterFor334
  %load387 = load i32, i32* %i, align 4
  %TINC388 = add i32 1, %load387
  store i32 %TINC388, i32* %i, align 4
  br label %forCon330

then397:                                          ; preds = %afterFor331
  %call399 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str10, i32 0, i32 0))
  br label %afterIf398

afterIf398:                                       ; preds = %then397, %afterFor331
  ret i32 0
}

define internal void @prints(i8* %s, i32 %line1, i1 %needNewLine2) {
prints_entry:
  %line = alloca i32, align 4
  store i32 %line1, i32* %line, align 4
  %needNewLine = alloca i1, align 1
  store i1 %needNewLine2, i1* %needNewLine, align 1
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %whileCond

whileLoop:                                        ; preds = %whileCond
  %load = load i32, i32* %i, align 4
  %load3 = load i32, i32* %line, align 4
  %MUL = mul i32 300, %load3
  %PLUS = add i32 %load, %MUL
  %elementPtr = getelementptr inbounds i8, i8* %s, i32 %PLUS
  %0 = load i8, i8* %elementPtr, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str0, i32 0, i32 0), i8 %0)
  %load4 = load i32, i32* %i, align 4
  %TINC = add i32 1, %load4
  store i32 %TINC, i32* %i, align 4
  br label %whileCond

whileCond:                                        ; preds = %whileLoop, %prints_entry
  %load5 = load i32, i32* %i, align 4
  %load6 = load i32, i32* %line, align 4
  %MUL7 = mul i32 300, %load6
  %PLUS8 = add i32 %load5, %MUL7
  %elementPtr9 = getelementptr inbounds i8, i8* %s, i32 %PLUS8
  %1 = load i8, i8* %elementPtr9, align 4
  %NE = icmp ne i8 %1, 0
  %2 = icmp ne i1 %NE, false
  br i1 %2, label %whileLoop, label %afterWhile

afterWhile:                                       ; preds = %whileCond
  %load10 = load i1, i1* %needNewLine, align 1
  %3 = icmp ne i1 %load10, false
  br i1 %3, label %then, label %afterIf

then:                                             ; preds = %afterWhile
  %call11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str1, i32 0, i32 0))
  br label %afterIf

afterIf:                                          ; preds = %then, %afterWhile
  ret void
}

define internal i32 @find(i8* %course, i8* %source, i32 %n1) {
find_entry:
  %n = alloca i32, align 4
  store i32 %n1, i32* %n, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %forCon

forLoop:                                          ; preds = %forCon
  store i32 0, i32* %j, align 4
  br label %whileCond

forCon:                                           ; preds = %afterIf, %find_entry
  %load19 = load i32, i32* %i, align 4
  %load20 = load i32, i32* %n, align 4
  %LT = icmp slt i32 %load19, %load20
  %0 = icmp ne i1 %LT, false
  br i1 %0, label %forLoop, label %afterFor

afterFor:                                         ; preds = %forCon
  ret i32 -1

whileLoop:                                        ; preds = %whileCond
  %load = load i32, i32* %j, align 4
  %TINC = add i32 1, %load
  store i32 %TINC, i32* %j, align 4
  br label %whileCond

whileCond:                                        ; preds = %whileLoop, %forLoop
  %load2 = load i32, i32* %j, align 4
  %load3 = load i32, i32* %i, align 4
  %MUL = mul i32 300, %load3
  %PLUS = add i32 %load2, %MUL
  %elementPtr = getelementptr inbounds i8, i8* %course, i32 %PLUS
  %1 = load i8, i8* %elementPtr, align 4
  %load4 = load i32, i32* %j, align 4
  %elementPtr5 = getelementptr inbounds i8, i8* %source, i32 %load4
  %2 = load i8, i8* %elementPtr5, align 4
  %EQ = icmp eq i8 %1, %2
  %load6 = load i32, i32* %j, align 4
  %elementPtr7 = getelementptr inbounds i8, i8* %source, i32 %load6
  %3 = load i8, i8* %elementPtr7, align 4
  %NE = icmp ne i8 %3, 0
  %AND = and i1 %EQ, %NE
  %4 = icmp ne i1 %AND, false
  br i1 %4, label %whileLoop, label %afterWhile

afterWhile:                                       ; preds = %whileCond
  %load8 = load i32, i32* %j, align 4
  %load9 = load i32, i32* %i, align 4
  %MUL10 = mul i32 300, %load9
  %PLUS11 = add i32 %load8, %MUL10
  %elementPtr12 = getelementptr inbounds i8, i8* %course, i32 %PLUS11
  %5 = load i8, i8* %elementPtr12, align 4
  %load13 = load i32, i32* %j, align 4
  %elementPtr14 = getelementptr inbounds i8, i8* %source, i32 %load13
  %6 = load i8, i8* %elementPtr14, align 4
  %EQ15 = icmp eq i8 %5, %6
  %7 = icmp ne i1 %EQ15, false
  br i1 %7, label %then, label %afterIf

then:                                             ; preds = %afterWhile
  %load16 = load i32, i32* %i, align 4
  ret i32 %load16
  br label %afterIf

afterIf:                                          ; preds = %then, %afterWhile
  %load17 = load i32, i32* %i, align 4
  %TINC18 = add i32 1, %load17
  store i32 %TINC18, i32* %i, align 4
  br label %forCon
}

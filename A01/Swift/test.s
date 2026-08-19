	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 15, 0	sdk_version 15, 4
	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	sub	sp, sp, #192
	stp	x20, x19, [sp, #160]
	stp	x29, x30, [sp, #176]
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	bl	_$s4test12calculateSumSiyF
	adrp	x8, _$s4test6resultSivp@PAGE
	str	x8, [sp, #32]
	str	x0, [x8, _$s4test6resultSivp@PAGEOFF]
	mov	w8, #1
	mov	x0, x8
	str	x0, [sp, #8]
	adrp	x8, _$sypN@GOTPAGE
	ldr	x8, [x8, _$sypN@GOTPAGEOFF]
	add	x1, x8, #8
	stur	x1, [x29, #-80]
	bl	_$ss27_allocateUninitializedArrayySayxG_BptBwlF
	str	x0, [sp, #88]
	mov	x8, x1
	ldr	x1, [sp, #8]
	str	x8, [sp, #80]
	mov	w8, #36
	mov	x0, x8
	str	x0, [sp, #16]
	bl	_$ss26DefaultStringInterpolationV15literalCapacity18interpolationCountABSi_SitcfC
	mov	x8, x1
	ldr	x1, [sp, #16]
	sub	x20, x29, #32
	str	x20, [sp, #56]
	stur	x0, [x29, #-32]
	stur	x8, [x29, #-24]
	adrp	x0, "l_.str.36.The sum of numbers from 1 to 10 is: "@PAGE
	add	x0, x0, "l_.str.36.The sum of numbers from 1 to 10 is: "@PAGEOFF
	mov	w8, #1
	str	w8, [sp, #44]
	and	w2, w8, #0x1
	bl	_$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
	str	x1, [sp, #24]
	bl	_$ss26DefaultStringInterpolationV13appendLiteralyySSF
	ldr	x20, [sp, #56]
	ldr	x0, [sp, #24]
	bl	_swift_bridgeObjectRelease
	ldr	x8, [sp, #32]
	ldr	x8, [x8, _$s4test6resultSivp@PAGEOFF]
	sub	x0, x29, #40
	stur	x8, [x29, #-40]
	adrp	x1, _$sSiN@GOTPAGE
	ldr	x1, [x1, _$sSiN@GOTPAGEOFF]
	adrp	x2, _$sSis23CustomStringConvertiblesWP@GOTPAGE
	ldr	x2, [x2, _$sSis23CustomStringConvertiblesWP@GOTPAGEOFF]
	bl	_$ss26DefaultStringInterpolationV06appendC0yyxs06CustomB11ConvertibleRzlF
	ldr	x20, [sp, #56]
	ldr	w8, [sp, #44]
	adrp	x0, l_.str.0.@PAGE
	add	x0, x0, l_.str.0.@PAGEOFF
	mov	x1, #0
	and	w2, w8, #0x1
	bl	_$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
	str	x1, [sp, #48]
	bl	_$ss26DefaultStringInterpolationV13appendLiteralyySSF
	ldr	x0, [sp, #48]
	bl	_swift_bridgeObjectRelease
	ldur	x8, [x29, #-32]
	str	x8, [sp, #72]
	ldur	x0, [x29, #-24]
	str	x0, [sp, #64]
	bl	_swift_bridgeObjectRetain
	ldr	x0, [sp, #56]
	bl	_$ss26DefaultStringInterpolationVWOh
	ldr	x1, [sp, #64]
	ldr	x0, [sp, #72]
	bl	_$sSS19stringInterpolationSSs013DefaultStringB0V_tcfC
	ldr	x9, [sp, #80]
	mov	x10, x0
	ldr	x0, [sp, #88]
	mov	x8, x1
	ldur	x1, [x29, #-80]
	adrp	x11, _$sSSN@GOTPAGE
	ldr	x11, [x11, _$sSSN@GOTPAGEOFF]
	str	x11, [x9, #24]
	str	x10, [x9]
	str	x8, [x9, #8]
	bl	_$ss27_finalizeUninitializedArrayySayxGABnlF
	stur	x0, [x29, #-48]
	bl	_$ss5print_9separator10terminatoryypd_S2StFfA0_
	stur	x0, [x29, #-72]
	stur	x1, [x29, #-56]
	bl	_$ss5print_9separator10terminatoryypd_S2StFfA1_
	ldur	x2, [x29, #-56]
	mov	x3, x0
	ldur	x0, [x29, #-48]
	mov	x4, x1
	ldur	x1, [x29, #-72]
	stur	x4, [x29, #-64]
	bl	_$ss5print_9separator10terminatoryypd_S2StF
	ldur	x0, [x29, #-64]
	bl	_swift_bridgeObjectRelease
	ldur	x0, [x29, #-56]
	bl	_swift_bridgeObjectRelease
	ldur	x0, [x29, #-48]
	bl	_swift_bridgeObjectRelease
	mov	w0, #0
	ldp	x29, x30, [sp, #176]
	ldp	x20, x19, [sp, #160]
	add	sp, sp, #192
	ret
	.cfi_endproc

	.private_extern	_$s4test12calculateSumSiyF
	.globl	_$s4test12calculateSumSiyF
	.p2align	2
_$s4test12calculateSumSiyF:
	.cfi_startproc
	sub	sp, sp, #144
	stp	x20, x19, [sp, #112]
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	str	xzr, [sp, #32]
	stur	xzr, [x29, #-24]
	add	x20, sp, #56
	mov	w8, #1
	str	x8, [sp, #56]
	mov	w8, #10
	str	x8, [sp, #64]
	adrp	x0, _$sSNySiGMD@PAGE
	add	x0, x0, _$sSNySiGMD@PAGEOFF
	bl	___swift_instantiateConcreteTypeFromMangledName
	str	x0, [sp, #24]
	bl	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWl
	mov	x1, x0
	ldr	x0, [sp, #24]
	sub	x8, x29, #56
	bl	_$sSlss16IndexingIteratorVyxG0B0RtzrlE04makeB0ACyF
	b	LBB1_1
LBB1_1:
	adrp	x0, _$ss16IndexingIteratorVySNySiGGMD@PAGE
	add	x0, x0, _$ss16IndexingIteratorVySNySiGGMD@PAGEOFF
	bl	___swift_instantiateConcreteTypeFromMangledName
	add	x8, sp, #40
	sub	x20, x29, #56
	bl	_$ss16IndexingIteratorV4next7ElementQzSgyF
	ldr	x8, [sp, #40]
	str	x8, [sp, #16]
	ldrb	w8, [sp, #48]
	tbnz	w8, #0, LBB1_5
	b	LBB1_2
LBB1_2:
	ldr	x8, [sp, #16]
	str	x8, [sp, #8]
	b	LBB1_3
LBB1_3:
	ldr	x9, [sp, #8]
	str	x9, [sp, #32]
	ldur	x8, [x29, #-24]
	adds	x8, x8, x9
	str	x8, [sp]
	cset	w8, vs
	tbnz	w8, #0, LBB1_6
	b	LBB1_4
LBB1_4:
	ldr	x8, [sp]
	stur	x8, [x29, #-24]
	b	LBB1_1
LBB1_5:
	ldur	x0, [x29, #-24]
	ldp	x29, x30, [sp, #128]
	ldp	x20, x19, [sp, #112]
	add	sp, sp, #144
	ret
LBB1_6:
	brk	#0x1
	.cfi_endproc

	.private_extern	_$ss26DefaultStringInterpolationVWOh
	.globl	_$ss26DefaultStringInterpolationVWOh
	.weak_definition	_$ss26DefaultStringInterpolationVWOh
	.p2align	2
_$ss26DefaultStringInterpolationVWOh:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	str	x0, [sp, #8]
	ldr	x0, [x0, #8]
	bl	_swift_bridgeObjectRelease
	ldr	x0, [sp, #8]
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret

	.private_extern	_$ss27_finalizeUninitializedArrayySayxGABnlF
	.globl	_$ss27_finalizeUninitializedArrayySayxGABnlF
	.weak_definition	_$ss27_finalizeUninitializedArrayySayxGABnlF
	.p2align	2
_$ss27_finalizeUninitializedArrayySayxGABnlF:
	.cfi_startproc
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x8, x1
	str	x8, [sp, #8]
	mov	x20, sp
	str	x0, [sp]
	mov	x0, #0
	bl	_$sSaMa
	bl	_$sSa12_endMutationyyF
	ldr	x0, [sp]
	ldp	x29, x30, [sp, #32]
	ldp	x20, x19, [sp, #16]
	add	sp, sp, #48
	ret
	.cfi_endproc

	.private_extern	_$ss5print_9separator10terminatoryypd_S2StFfA0_
	.globl	_$ss5print_9separator10terminatoryypd_S2StFfA0_
	.weak_definition	_$ss5print_9separator10terminatoryypd_S2StFfA0_
	.p2align	2
_$ss5print_9separator10terminatoryypd_S2StFfA0_:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x0, "l_.str.1. "@PAGE
	add	x0, x0, "l_.str.1. "@PAGEOFF
	mov	w8, #1
	mov	x1, x8
	mov	w8, #1
	and	w2, w8, #0x1
	bl	_$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
	ldp	x29, x30, [sp], #16
	ret
	.cfi_endproc

	.private_extern	_$ss5print_9separator10terminatoryypd_S2StFfA1_
	.globl	_$ss5print_9separator10terminatoryypd_S2StFfA1_
	.weak_definition	_$ss5print_9separator10terminatoryypd_S2StFfA1_
	.p2align	2
_$ss5print_9separator10terminatoryypd_S2StFfA1_:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x0, "l_.str.1.\n"@PAGE
	add	x0, x0, "l_.str.1.\n"@PAGEOFF
	mov	w8, #1
	mov	x1, x8
	mov	w8, #1
	and	w2, w8, #0x1
	bl	_$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
	ldp	x29, x30, [sp], #16
	ret
	.cfi_endproc

	.private_extern	___swift_instantiateConcreteTypeFromMangledName
	.globl	___swift_instantiateConcreteTypeFromMangledName
	.weak_definition	___swift_instantiateConcreteTypeFromMangledName
	.p2align	2
___swift_instantiateConcreteTypeFromMangledName:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	str	x0, [sp, #8]
	ldr	x8, [x0]
	str	x8, [sp, #16]
	mov	x0, x8
	stur	x0, [x29, #-8]
	tbnz	x8, #63, LBB6_2
	b	LBB6_1
LBB6_1:
	ldur	x0, [x29, #-8]
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	ret
LBB6_2:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	mov	x10, #0
	subs	x1, x10, x9, asr #32
	add	x0, x8, w9, sxtw
	mov	x3, #0
	mov	x2, x3
	bl	_swift_getTypeByMangledNameInContext2
	ldr	x8, [sp, #8]
	str	x0, [x8]
	stur	x0, [x29, #-8]
	b	LBB6_1

	.private_extern	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWl
	.globl	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWl
	.weak_definition	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWl
	.p2align	2
_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWl:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	adrp	x8, _$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL@PAGE
	ldr	x8, [x8, _$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL@PAGEOFF]
	mov	x0, x8
	str	x0, [sp, #8]
	cbnz	x8, LBB7_2
	b	LBB7_1
LBB7_1:
	adrp	x0, _$sSNySiGMD@PAGE
	add	x0, x0, _$sSNySiGMD@PAGEOFF
	bl	___swift_instantiateConcreteTypeFromMangledNameAbstract
	str	x0, [sp]
	bl	_$sS2iSZsWl
	ldr	x1, [sp]
	add	x2, sp, #16
	adrp	x8, _$sSiSxsWP@GOTPAGE
	ldr	x8, [x8, _$sSiSxsWP@GOTPAGEOFF]
	str	x8, [sp, #16]
	str	x0, [sp, #24]
	adrp	x0, _$sSNyxGSlsSxRzSZ6StrideRpzrlMc@GOTPAGE
	ldr	x0, [x0, _$sSNyxGSlsSxRzSZ6StrideRpzrlMc@GOTPAGEOFF]
	bl	_swift_getWitnessTable
	adrp	x9, _$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL@PAGE
	add	x9, x9, _$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL@PAGEOFF
	mov	x8, x0
	stlr	x8, [x9]
	str	x0, [sp, #8]
	b	LBB7_2
LBB7_2:
	ldr	x0, [sp, #8]
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	ret

	.private_extern	___swift_instantiateConcreteTypeFromMangledNameAbstract
	.globl	___swift_instantiateConcreteTypeFromMangledNameAbstract
	.weak_definition	___swift_instantiateConcreteTypeFromMangledNameAbstract
	.p2align	2
___swift_instantiateConcreteTypeFromMangledNameAbstract:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	str	x0, [sp, #8]
	ldr	x8, [x0]
	str	x8, [sp, #16]
	mov	x0, x8
	stur	x0, [x29, #-8]
	tbnz	x8, #63, LBB8_2
	b	LBB8_1
LBB8_1:
	ldur	x0, [x29, #-8]
	ldp	x29, x30, [sp, #32]
	add	sp, sp, #48
	ret
LBB8_2:
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	mov	x10, #0
	subs	x2, x10, x9, asr #32
	add	x1, x8, w9, sxtw
	mov	w8, #255
	mov	x0, x8
	mov	x4, #0
	mov	x3, x4
	bl	_swift_getTypeByMangledNameInContextInMetadataState2
	ldr	x8, [sp, #8]
	str	x0, [x8]
	stur	x0, [x29, #-8]
	b	LBB8_1

	.private_extern	_$sS2iSZsWl
	.globl	_$sS2iSZsWl
	.weak_definition	_$sS2iSZsWl
	.p2align	2
_$sS2iSZsWl:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	adrp	x8, _$sS2iSZsWL@PAGE
	ldr	x8, [x8, _$sS2iSZsWL@PAGEOFF]
	mov	x0, x8
	str	x0, [sp, #8]
	cbnz	x8, LBB9_2
	b	LBB9_1
LBB9_1:
	ldr	x2, [sp]
	adrp	x0, _$sSiSZsMc@GOTPAGE
	ldr	x0, [x0, _$sSiSZsMc@GOTPAGEOFF]
	adrp	x1, _$sSiN@GOTPAGE
	ldr	x1, [x1, _$sSiN@GOTPAGEOFF]
	bl	_swift_getWitnessTable
	adrp	x9, _$sS2iSZsWL@PAGE
	add	x9, x9, _$sS2iSZsWL@PAGEOFF
	mov	x8, x0
	stlr	x8, [x9]
	str	x0, [sp, #8]
	b	LBB9_2
LBB9_2:
	ldr	x0, [sp, #8]
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret

	.private_extern	_$sSa12_endMutationyyF
	.globl	_$sSa12_endMutationyyF
	.weak_definition	_$sSa12_endMutationyyF
	.p2align	2
_$sSa12_endMutationyyF:
	.cfi_startproc
	ldr	x8, [x20]
	str	x8, [x20]
	ret
	.cfi_endproc

	.private_extern	_$s4test6resultSivp
	.globl	_$s4test6resultSivp
.zerofill __DATA,__common,_$s4test6resultSivp,8,3
	.section	__TEXT,__cstring,cstring_literals
	.p2align	4, 0x0
"l_.str.36.The sum of numbers from 1 to 10 is: ":
	.asciz	"The sum of numbers from 1 to 10 is: "

l_.str.0.:
	.space	1

	.private_extern	"_symbolic SNySiG"
	.section	__TEXT,__swift5_typeref
	.globl	"_symbolic SNySiG"
	.weak_definition	"_symbolic SNySiG"
	.p2align	1, 0x0
"_symbolic SNySiG":
	.ascii	"SNySiG"
	.byte	0

	.private_extern	_$sSNySiGMD
	.section	__DATA,__data
	.globl	_$sSNySiGMD
	.weak_definition	_$sSNySiGMD
	.p2align	3, 0x0
_$sSNySiGMD:
	.long	"_symbolic SNySiG"-_$sSNySiGMD
	.long	4294967290

	.private_extern	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL
	.globl	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL
	.weak_definition	_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL
	.p2align	3, 0x0
_$sSNySiGSNyxGSlsSxRzSZ6StrideRpzrlWL:
	.quad	0

	.private_extern	_$sS2iSZsWL
	.globl	_$sS2iSZsWL
	.weak_definition	_$sS2iSZsWL
	.p2align	3, 0x0
_$sS2iSZsWL:
	.quad	0

	.private_extern	"_symbolic _____ySNySiGG s16IndexingIteratorV"
	.section	__TEXT,__swift5_typeref
	.globl	"_symbolic _____ySNySiGG s16IndexingIteratorV"
	.weak_definition	"_symbolic _____ySNySiGG s16IndexingIteratorV"
	.p2align	1, 0x0
"_symbolic _____ySNySiGG s16IndexingIteratorV":
	.byte	2
Ltmp0:
	.long	_$ss16IndexingIteratorVMn@GOT-Ltmp0
	.ascii	"ySNySiGG"
	.byte	0

	.private_extern	_$ss16IndexingIteratorVySNySiGGMD
	.section	__DATA,__data
	.globl	_$ss16IndexingIteratorVySNySiGGMD
	.weak_definition	_$ss16IndexingIteratorVySNySiGGMD
	.p2align	3, 0x0
_$ss16IndexingIteratorVySNySiGGMD:
	.long	"_symbolic _____ySNySiGG s16IndexingIteratorV"-_$ss16IndexingIteratorVySNySiGGMD
	.long	4294967283

	.section	__TEXT,__swift5_entry,regular,no_dead_strip
	.p2align	2, 0x0
l_entry_point:
	.long	_main-l_entry_point
	.long	0

	.section	__TEXT,__cstring,cstring_literals
"l_.str.1.\n":
	.asciz	"\n"

"l_.str.1. ":
	.asciz	" "

	.private_extern	___swift_reflection_version
	.section	__TEXT,__const
	.globl	___swift_reflection_version
	.weak_definition	___swift_reflection_version
	.p2align	1, 0x0
___swift_reflection_version:
	.short	3

	.no_dead_strip	_$s4test6resultSivp
	.no_dead_strip	_main
	.no_dead_strip	l_entry_point
	.no_dead_strip	___swift_reflection_version
	.linker_option "-lswiftCore"
	.linker_option "-lobjc"
	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	100730688

.subsections_via_symbols

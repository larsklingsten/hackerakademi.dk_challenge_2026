0000000000001a6f <has_letter_streak>:
    1a6f:	55                   	push   %rbp
    1a70:	48 89 e5             	mov    %rsp,%rbp
    1a73:	48 83 ec 20          	sub    $0x20,%rsp
    1a77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1a7b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    1a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a82:	48 89 c7             	mov    %rax,%rdi
    1a85:	e8 c6 f5 ff ff       	call   1050 <strlen@plt>
    1a8a:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1a8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1a94:	eb 61                	jmp    1af7 <has_letter_streak+0x88>
    1a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1a9d:	eb 3a                	jmp    1ad9 <has_letter_streak+0x6a>
    1a9f:	e8 6c f6 ff ff       	call   1110 <__ctype_b_loc@plt>
    1aa4:	48 8b 00             	mov    (%rax),%rax
    1aa7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    1aaa:	8b 55 f8             	mov    -0x8(%rbp),%edx
    1aad:	01 ca                	add    %ecx,%edx
    1aaf:	48 63 ca             	movslq %edx,%rcx
    1ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1ab6:	48 01 ca             	add    %rcx,%rdx
    1ab9:	0f b6 12             	movzbl (%rdx),%edx
    1abc:	48 0f be d2          	movsbq %dl,%rdx
    1ac0:	48 01 d2             	add    %rdx,%rdx
    1ac3:	48 01 d0             	add    %rdx,%rax
    1ac6:	0f b7 00             	movzwl (%rax),%eax
    1ac9:	0f b7 c0             	movzwl %ax,%eax
    1acc:	25 00 04 00 00       	and    $0x400,%eax
    1ad1:	85 c0                	test   %eax,%eax
    1ad3:	74 0e                	je     1ae3 <has_letter_streak+0x74>
    1ad5:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1ad9:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1adc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
    1adf:	7c be                	jl     1a9f <has_letter_streak+0x30>
    1ae1:	eb 01                	jmp    1ae4 <has_letter_streak+0x75>
    1ae3:	90                   	nop
    1ae4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1ae7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
    1aea:	75 07                	jne    1af3 <has_letter_streak+0x84>
    1aec:	b8 01 00 00 00       	mov    $0x1,%eax
    1af1:	eb 16                	jmp    1b09 <has_letter_streak+0x9a>
    1af3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1af7:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1afa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1afd:	01 d0                	add    %edx,%eax
    1aff:	39 45 f4             	cmp    %eax,-0xc(%rbp)
    1b02:	7f 92                	jg     1a96 <has_letter_streak+0x27>
    1b04:	b8 00 00 00 00       	mov    $0x0,%eax
    1b09:	c9                   	leave
    1b0a:	c3                   	ret

0000000000001b0b <count_one_bits>:
    1b0b:	55                   	push   %rbp
    1b0c:	48 89 e5             	mov    %rsp,%rbp
    1b0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1b22:	eb 31                	jmp    1b55 <count_one_bits+0x4a>
    1b24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1b2b:	eb 1d                	jmp    1b4a <count_one_bits+0x3f>
    1b2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b31:	0f b6 00             	movzbl (%rax),%eax
    1b34:	0f be d0             	movsbl %al,%edx
    1b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1b3a:	89 c1                	mov    %eax,%ecx
    1b3c:	d3 fa                	sar    %cl,%edx
--
0000000000001b65 <one_bits_modulo>:
    1b65:	55                   	push   %rbp
    1b66:	48 89 e5             	mov    %rsp,%rbp
    1b69:	48 83 ec 10          	sub    $0x10,%rsp
    1b6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1b71:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1b74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b78:	48 89 c7             	mov    %rax,%rdi
    1b7b:	e8 8b ff ff ff       	call   1b0b <count_one_bits>
    1b80:	99                   	cltd
    1b81:	f7 7d f4             	idivl  -0xc(%rbp)
    1b84:	89 d0                	mov    %edx,%eax
    1b86:	85 c0                	test   %eax,%eax
    1b88:	0f 94 c0             	sete   %al
    1b8b:	0f b6 c0             	movzbl %al,%eax
    1b8e:	c9                   	leave
    1b8f:	c3                   	ret

0000000000001b90 <least_one_bits>:
    1b90:	55                   	push   %rbp
    1b91:	48 89 e5             	mov    %rsp,%rbp
    1b94:	48 83 ec 10          	sub    $0x10,%rsp
    1b98:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1b9c:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1b9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba3:	48 89 c7             	mov    %rax,%rdi
    1ba6:	e8 60 ff ff ff       	call   1b0b <count_one_bits>
    1bab:	39 45 f4             	cmp    %eax,-0xc(%rbp)
    1bae:	0f 9e c0             	setle  %al
    1bb1:	0f b6 c0             	movzbl %al,%eax
    1bb4:	c9                   	leave
    1bb5:	c3                   	ret

0000000000001bb6 <check_password>:
    1bb6:	55                   	push   %rbp
    1bb7:	48 89 e5             	mov    %rsp,%rbp
    1bba:	48 83 ec 20          	sub    $0x20,%rsp
    1bbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1bc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
--
    1de7:	e8 83 fc ff ff       	call   1a6f <has_letter_streak>
    1dec:	85 c0                	test   %eax,%eax
    1dee:	75 30                	jne    1e20 <check_password+0x26a>
    1df0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1df4:	41 b8 05 00 00 00    	mov    $0x5,%r8d
    1dfa:	48 8d 15 af 04 00 00 	lea    0x4af(%rip),%rdx        # 22b0 <_fini+0x3c4>
    1e01:	48 89 d1             	mov    %rdx,%rcx
    1e04:	ba 00 00 00 00       	mov    $0x0,%edx
    1e09:	be 04 00 00 00       	mov    $0x4,%esi
    1e0e:	48 89 c7             	mov    %rax,%rdi
    1e11:	b8 00 00 00 00       	mov    $0x0,%eax
    1e16:	e8 75 f2 ff ff       	call   1090 <pam_prompt@plt>
    1e1b:	e9 c5 00 00 00       	jmp    1ee5 <check_password+0x32f>
    1e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1e24:	be 3c 00 00 00       	mov    $0x3c,%esi
    1e29:	48 89 c7             	mov    %rax,%rdi
    1e2c:	e8 5f fd ff ff       	call   1b90 <least_one_bits>
    1e31:	85 c0                	test   %eax,%eax
    1e33:	75 30                	jne    1e65 <check_password+0x2af>
    1e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e39:	41 b8 3c 00 00 00    	mov    $0x3c,%r8d
    1e3f:	48 8d 15 aa 04 00 00 	lea    0x4aa(%rip),%rdx        # 22f0 <_fini+0x404>
    1e46:	48 89 d1             	mov    %rdx,%rcx
    1e49:	ba 00 00 00 00       	mov    $0x0,%edx
    1e4e:	be 04 00 00 00       	mov    $0x4,%esi
    1e53:	48 89 c7             	mov    %rax,%rdi
    1e56:	b8 00 00 00 00       	mov    $0x0,%eax
    1e5b:	e8 30 f2 ff ff       	call   1090 <pam_prompt@plt>
    1e60:	e9 80 00 00 00       	jmp    1ee5 <check_password+0x32f>
    1e65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1e69:	be 11 00 00 00       	mov    $0x11,%esi
    1e6e:	48 89 c7             	mov    %rax,%rdi
    1e71:	e8 ef fc ff ff       	call   1b65 <one_bits_modulo>
    1e76:	85 c0                	test   %eax,%eax
    1e78:	75 2d                	jne    1ea7 <check_password+0x2f1>
    1e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e7e:	41 b8 11 00 00 00    	mov    $0x11,%r8d
    1e84:	48 8d 15 9d 04 00 00 	lea    0x49d(%rip),%rdx        # 2328 <_fini+0x43c>
    1e8b:	48 89 d1             	mov    %rdx,%rcx
    1e8e:	ba 00 00 00 00       	mov    $0x0,%edx
    1e93:	be 04 00 00 00       	mov    $0x4,%esi
    1e98:	48 89 c7             	mov    %rax,%rdi
    1e9b:	b8 00 00 00 00       	mov    $0x0,%eax
    1ea0:	e8 eb f1 ff ff       	call   1090 <pam_prompt@plt>
    1ea5:	eb 3e                	jmp    1ee5 <check_password+0x32f>
    1ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1eab:	48 89 c7             	mov    %rax,%rdi
    1eae:	e8 34 fa ff ff       	call   18e7 <is_palindrome>
    1eb3:	85 c0                	test   %eax,%eax
    1eb5:	75 27                	jne    1ede <check_password+0x328>
    1eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ebb:	48 8d 15 96 04 00 00 	lea    0x496(%rip),%rdx        # 2358 <_fini+0x46c>
    1ec2:	48 89 d1             	mov    %rdx,%rcx

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 150000

struct Node {
    int ne[26], count;
    char *word;
} node[N];

int root, cnt = 1;

/*
.section .bss
trie_nodes: .space 224*100000 # 26*8 + 8 + 8
.section .data
trie_root: .quad 0
trie_node_count: .quad 1
*/

int add() {
    node[cnt].count = 0;
    for(int i = 0; i < 26; ++i) node[cnt].ne[i] = 0;
    node[cnt].word = 0;
    ++cnt;
    return cnt - 1;
}
/*
trie_add_node:
    # 输出: RAX = 新建 trie 节点的编号
    mov trie_node_count(%rip), %rax
    add $1, trie_node_count(%rip)
    ret
*/

void insert(const char *s) {
    int len = strlen(s);
    int now = root;
    for(int i = 0; i < len; ++i) {
        int *p = &(node[now].ne[s[i] - '0']);
        if(*p == 0) *p = add();
        if(i == len - 1) {
            if(node[now].count == 0) {
                char *str = (char*)malloc((size_t)sizeof(char) * (len + 1));
                for(int j = 0; j < len; ++j)
                    str[j] = s[j];
                str[len] = 0;
                node[now].word = str;
            }
            ++node[now].count;
        }
        now = *p;
    }
}

/*
trie_insert:
    # 输入：RDI = 输入字符串的首地址
    push %rbx
    push %r12
    mov %rdi, %rsi
    call strlen
    mov %rdi, %rsi # RSI = s[]
    mov %rax, %r12 # r12 = len
    mov trie_root(%rip), %rdx # RDX = now
    xor %rcx, %rcx # RCX = i

trie_insert_loop:
    cmp %r12, %rcx
    jge trie_insert_done

    movzx  (%rsi,%rcx), %eax     # 读取 s[i]
    sub    $'0', %al         # 计算 k = s[i] - '0'
    movzx  %al, %ebx             # %ebx = k

    lea    trie_nodes(%rip), %r11
    mov    %rdx, %r8
    imul   $224, %r8, %r8         # r8 = rdx * 224
    add    %r11, %r8               # r8 = &trie_nodes[rdx]

    lea    (%r8,%rbx,8), %r9    # r9 = &ne[k]
    cmp    $0, (%r9)
    jne    trie_node_exist
    call   trie_add_node
    mov    %rax, (%r9)

trie_node_exist:
    mov    %r12, %r10
    decq   %r10
    cmp    %rcx, %r10
    jne    trie_str_not_end
    # 字符串末尾
    mov    208(%r8), %r11           # count 的偏移 = 26*8 = 208
    test   %r11, %r11
    jnz    trie_str_exist
    mov %rsi, %rdi
    call strdup
    mov %rax, 216(%r8)
    
trie_str_exist:
    add    $1, 208(%r8)

trie_str_not_end:
    mov    (%r9), %rdx
    incq %rcx
    jmp trie_insert_loop

trie_insert_done:
    pop %r12
    pop %rbx
    ret
*/

int get_max() {
    int val = 0, pos = 0;
    for(int i = 0; i < cnt; ++i)
        if(val < node[i].count)
            pos = i;
    return pos;
    /*
        pos = 0 -> no word
        else ans = node[pos].word
    */
}
/*
trie_get_max:
    xor %r8, %r8
    xor %rax, %rax
    xor %rcx, %rcx
    mov trie_node_count(%rip), %rdx

trie_get_max_loop:
    cmp %rdx, %rcx
    jge trie_get_max_done
    lea trie_nodes(%rip), %r10
    mov %rcx, %r9
    imul $224, %r9, %r9
    add %r10, %r9 # r9 = &node[i]
    cmp 208(%r9), %r8
    jge trie_get_max_loop
    mov %rcx, %rax
    jmp trie_get_max_loop

trie_get_max_done:
    ret
*/

int main() {

    return 0;
}
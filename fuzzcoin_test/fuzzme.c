#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

int g_cnt;
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t len) {
    printf("test case %d\n", g_cnt++);
    uint64_t* p = data;

for(int i=0; i<4; i++){
    if(len>8){
        if(data[0]>127){
        if(data[1]<88){
        if(data[3]>55){
        if(data[2]<81){
        if(data[4]>81){
        if(data[5]<81){
        if(data[6]==61){
            *(p-999)=1;
        }}}}}}}
    }
}
    return 0;
}

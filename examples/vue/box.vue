<template>
  <div>
    <text style="font-size: 60px;" @click="add">play ground ar demo</text>
    <scene ref="scene" style="height: 900;width: 750" @tap="tap"></scene>
  </div>
</template>

<script>
  module.exports = {
    data: function () {
      return {
        index: 0
      };
    },
    mounted: function () {
      console.log('Data observation finished')
      this.$refs['scene'].addNode({
        name:'color',
        width:0.1,
        height:0.1,
        length:0.1,
        chamferRadius:0,
        vector:{
          x:0.1,
          y:0.1,
          z:-0.5
        },
        contents:{
          type:'color',
          name:'red'
        }
      });
    }
  }
</script>
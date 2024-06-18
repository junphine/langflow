interface ISelectDirectives {
    wrap: any
    fn: null|Function
    select:TSelect
}
interface TSelect {
    inserted:Function
    unbind:Function
}
export   const selectDirectives:ISelectDirectives =  {
    wrap: null,
    fn: null,
    select: {
      inserted (el, binding, vnode) {
        let { data, rowHeight, startIndex, callback, filterable } = binding.value;
        const {
          componentInstance: { $children: children }
        } = vnode;
        const selectDown = children[children.length - 1];
        const [elScrollBar] = selectDown.$children;
        const [wrap] = elScrollBar.$el.childNodes;
        const scrollView = wrap.getElementsByClassName('el-scrollbar__view')[0];
        const total = data.length; // 所有数据的总条数
        // 设置el-scrollbar__view的高度
        if (filterable) {
          scrollView.style.height = 'auto';
        } else {
          scrollView.style.height = `${total * rowHeight}px`;
        }
        let timer = false;
        const fn = () => {
          if (timer) {
            return;
          }
          timer = true;
          const requestId = setTimeout(() => {
            timer = false;
            const scrollTop = wrap.scrollTop;
            // 计算当前滚动位置，获取当前开始的起始位置
            const currentIndex = Math.floor(scrollTop / rowHeight);
            // console.log(startIndex, 'startIndex222', currentIndex);
            // 根据滚动条获取当前索引与起始索引不相等时，将滚动的当前位置设置为起始位置
            if (currentIndex !== startIndex) {
              startIndex = Math.max(currentIndex, 0);
            }
            const paddingTop = `${startIndex * rowHeight}px`;
            scrollView.style.paddingTop = paddingTop;
            // eslint-disable-next-line standard/no-callback-literal
            callback({ startIndex, scrollView });
          }, 100);
          if (!requestId) {
            clearTimeout(requestId);
          }
        };
        selectDirectives.fn = fn;
        selectDirectives.wrap = wrap;
        wrap.addEventListener('scroll', fn, false);
      },
      unbind () {
        selectDirectives.wrap.removeEventListener('scroll', selectDirectives.fn);
      }
    }
  };
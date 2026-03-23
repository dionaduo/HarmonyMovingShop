# 鸿蒙状态管理装饰器 V1 vs V2 对比

## 一、核心装饰器对比

| 功能分类 | V1 装饰器 | V2 装饰器 | 主要区别与优势 |
| :--- | :--- | :--- | :--- |
| **组件声明** | `@Component` | `@ComponentV2` | V2 组件内必须使用 V2 状态装饰器，输入输出职责更明确 |
| **内部状态** | `@State` | `@Local` | V2 不接受外部初始化，职责单一；V1 可被外部初始化 |
| **外部输入** | `@Prop` | `@Param` | V2 统一外部传参语法，职责更清晰 |
| **双向同步** | `@Link` | `@Param` + `@Event` | **V2 移除 @Link**，改为单向数据流（数据向下，事件向上） |
| **跨层级传递** | `@Provide` / `@Consume` | `@Provider` / `@Consumer` | 功能相似，V2 别名匹配规则更严格 |
| **深度观测** | `@Observed` / `@ObjectLink` | `@ObservedV2` / `@Trace` | **V2 核心升级**：自动深度监听，代码量显著减少 |
| **监听变化** | `@Watch` | `@Monitor` | V2 可精准监听特定属性，并可获取变化前后的值 |
| **计算属性** | 无 | `@Computed` | V2 新增，自动缓存计算结果，性能更优 |

---

## 二、V2 核心优势

### 1. 单向数据流更清晰

```typescript
// V1 方式（双向绑定）
@Link count: number

// V2 方式（单向数据流）
@Param count: number
@Event onChange: (value: number) => void
# CS169 hw-rails-intro（CHIP 5.3 RottenPotatoes 补足 hw-rails-intro）

## 已通过的公开验证（2026-11-08）

验收分支 `edidada/cs169-hw`，最终 HEAD `4a936a9abf9dd8b0ccc32f816ca0193cf0853765`，[Actions run](https://github.com/edidada/cs169-hw-rails-intro/actions/runs)（branch push 成功）14/14 通过：

- movies CRUD 全套（基线，movies_spec.rb）：6 例
- 评为过滤（默认全部勾选、带 ratings 参数时只显示被选与保持勾选）：2 例
- 排序（title/release_date 列头链接 + `hilite` 强调、评级过滤在排序中保留）：3 例
- session 记忆（两次访问间恢复排序与过滤）：1 例

## 实现

- `app/controllers/movies_controller.rb`：`Movie.where(rating: selected)` + `order(sort_key)`；把 `sort` 与 `ratings` 存进 session；访问无参时回退到记忆态；`ALL_RATINGS` 白名单保证安全；`@sort` 与 `@selected_ratings` 供视图使用。
- `app/views/movies/index.html.erb`：新增 `form#ratings_form`（每 rating 的 `check_box_tag` id=`ratings_<R>`，提交按钮 id=`ratings_submit`）、列头 `th#title_header`/`th#release_date_header` 内链接携带 sort 与当前 filter 参数、`class="hilite bg-warning"` 标注当前排序列。
- 判分：官方 `spec/requests/movie_list_spec.rb` + `movies_spec.rb` 未动，是官方设计好的行为级断言（依靠列头 id 与 form 结构，不指定实现细节）。

## 边界与局限

- 这是 action 层公开 spec 的验收，不包含部署到 Render/Heroku 后的端到端浏览验收（指令的 cloud deploy 部分），也不宣称 Gradescore 私有评分覆盖。
- 上一轮 `index_by` 误用（hance 'checked' 全空、第 3/4 例与 spec 突击）已修复；官方仓库原始 spec 文件未改。

## CI 失败史（保留）

- r1 4 failures 因视图里 `@checked_ratings` 错误构建；r2 修复并回填。

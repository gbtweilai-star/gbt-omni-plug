# omni_plug

**One capability bit from GBT V8, packaged standalone.** No. 138 of 341,
`llm` domain (LLM).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 万能插：把「能力位」拓成「插座」——任何外部对象（process/file/api/web/**app**）插一个描述符就变成一根可扫可控的分支。op=status/sockets/energy/selftest 为**读类直连**；plug 只做存在性探测；run **真执行**（按插座类型过门：process→process_execute · file写→filesystem_write · api→external_llm+data_export · web/app→desktop_control+privacy_read（app 还能 do=launch 起进程）· 未知插座 fail-closed）。本件**从 V8 自己的树里长出**（不 import V9）：抽插座照 V9 那套，**门留在 V8 这边** —— V9 的 run_plugged 里 process 直接 subprocess、file 直接写盘，没有作用域校验，正是它缺的一环。三条纪律：不攻击/不绕授权校验 · 凭据只从 env 取且绝不回显原文 · 每插每跑都落账。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-omni-plug.git
cd gbt-omni-plug
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_omni_plug info                  # capability card
python -m gbt_omni_plug spec --json           # machine-readable contract
python -m gbt_omni_plug check --payload '{}'
python -m gbt_omni_plug run   --payload '{}'
```

Real `info` output from this machine:

```text
omni_plug  (llm)  v1.0.0
----------------------------------------
万能插：把「能力位」拓成「插座」——任何外部对象（process/file/api/web/**app**）插一个描述符就变成一根可扫可控的分支。op=status/sockets/energy/selftest 为**读类直连**；plug 只做存在性探测；run **真执行**（按插座类型过门：process→process_execute · file写→filesystem_write · api→external_llm+data_export · web/app→desktop_control+privacy_read（app 还能 do=launch 起进程）· 未知插座 fail-closed）。本件**从 V8 自己的树里长出**（不 import V9）：抽插座照 V9 那套，**门留在 V8 这边** —— V9 的 run_plugged 里 process 直接 subprocess、file 直接写盘，没有作用域校验，正是它缺的一环。三条纪律：不攻击/不绕授权校验 · 凭据只从 env 取且绝不回显原文 · 每插每跑都落账。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : process, file, api, web
```

Wire a real implementation:

```python
from gbt_omni_plug import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`process`、`file`、`api`、`web`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `omni_plug` |
| domain | `llm` |
| handler | `omni_plug` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [llm/omni_plug](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/llm/omni_plug.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.

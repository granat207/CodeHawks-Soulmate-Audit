<p align="center">
<img src="https://res.cloudinary.com/droqoz7lg/image/upload/q_90/dpr_2.0/c_fill,g_auto,h_320,w_320/f_auto/v1/company/jlaqqfofafa01emq3nh8?_a=BATAUVAA0" width="400" alt="soulmate">
<br/>


## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

# Usage

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

# Audit Scope Details

- Commit Hash:
- In Scope:
  (For this contest, just use the main branch)

```
Hash:
```

## Compatibilities

- Solc Version: `0.8.23 < 0.9.0`
- Chain(s) to deploy contract to:
  - Ethereum

# Roles

None

# Known Issues

- Eventually, the counter used to give ids will reach the `type(uint256).max` and no more will be able to be minted. This is known and can be ignored.

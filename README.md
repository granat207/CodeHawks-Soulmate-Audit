<p align="center">
<img src="https://res.cloudinary.com/droqoz7lg/image/upload/q_90/dpr_2.0/c_fill,g_auto,h_320,w_320/f_auto/v1/company/jlaqqfofafa01emq3nh8?_a=BATAUVAA0" width="400" alt="soulmate">
<br/>


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

- Commit Hash: Main

## Compatibilities

- Solc Version: `0.8.23 < 0.9.0`
- Chain(s) to deploy contract to:
  - Ethereum

# Roles

None

# Known Issues

- Eventually, the counter used to give ids will reach the `type(uint256).max` and no more will be able to be minted. This is known and can be ignored.

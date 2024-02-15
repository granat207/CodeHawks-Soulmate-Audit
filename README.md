# Description 
Soulmate Audit by Daniel Vigo. 

Soulmate is a protocol made by CodeHawks, you can see this in the section "First Fligths" on the CodeHawks official Website.


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

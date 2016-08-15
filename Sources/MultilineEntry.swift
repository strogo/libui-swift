import clibui

class MultilineEntry: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	init(wrapping:Bool=true) {

		if wrapping {
			self.op = clibui.uiNewMultilineEntry()
		} else {
			self.op = clibui.uiNewNonWrappingMultilineEntry()
		}

		self.onChangedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(text:String) -> Void {
		clibui.uiMultilineEntryAppend(self.op, text)
	}

	var text:String {
		get {
			return String(cString: clibui.uiEntryText(self.op))
		}
		set {
			clibui.uiEntrySetText(self.op, newValue)
		}
	}

	var readonly:Bool {
		get {
			return clibui.uiEntryReadOnly(self.op) == 1
		}
		set {
			clibui.uiEntrySetReadOnly(self.op, newValue ? 1 : 0)
		}
	}

	func on(changed: () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiEntryOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<MultilineEntry>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}